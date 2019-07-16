//
//  PlayStageViewModel.swift
//  Playor
//
//  Created by Behrad Kazemi on 6/17/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SuggestionPlatform
import NetworkPlatform
import Domain
final class PlayStageViewModel: ViewModelType {
	
	private let navigator: PlayStageNavigator
	private let playerUsecase: ToolbarUsecase
	private let dataUsecase: PlayStageUsecase
	init(navigator: PlayStageNavigator, playerUsecase: ToolbarUsecase, dataUsecase: PlayStageUsecase) {
		self.navigator = navigator
		self.playerUsecase = playerUsecase
		self.dataUsecase = dataUsecase
	}
	
	func transform(input: Input) -> Output {
		let errorTracker = ErrorTracker()
		let fetchingTracker = ActivityIndicator()
		let shouldBlur = input.mainScrollViewContentOffset.map { (point) -> Bool in
			print(point)
			return point.y > -90 ? true : false
			
		}
		let dataResponse = dataUsecase.getDataModel().trackError(errorTracker).trackActivity(fetchingTracker)
		
		let albumSection = dataResponse.flatMapLatest { [unowned self](response) -> Observable<[SectionItem]?> in
				var result = Observable<[SectionItem]?>.just(nil)
			if let safeResponse = response.albums{
				result = self.dataUsecase.toArtwork(items: safeResponse).map({ (artworks) -> [SectionItem] in
					return zip(artworks, safeResponse).map({ (artwork, album) -> SectionItem in
						return SectionItem.FeatureAlbumSectionItem(viewModel: StageAlbumFeatureBannerViewModel(album: album, artwork: artwork))
					})
				})
			}
			return result
		}
		
		let recentSection = dataResponse.flatMapLatest { [unowned self](response) -> Observable<[SectionItem]?> in
			if let safeResponse = response.recent {
				return self.dataUsecase.toArtwork(items: safeResponse).map({ (artworks) -> [SectionItem] in
					
					return zip(artworks, safeResponse).map({ (artwork,music) -> SectionItem in
						return SectionItem.TrackSectionItem(viewModel: CommonSongCellVM(Music: music, artwork: artwork))
					})
				})
			}
			return Observable<[SectionItem]?>.just(nil)
		}
		
		let bestOfArtistsSection = dataResponse.flatMapLatest { [unowned self](response) -> Observable<[SectionItem]?> in
			var result = Observable<[SectionItem]?>.just(nil)
			if let safeResponse = response.bestOfArtists{
				result = self.dataUsecase.toArtwork(items: safeResponse).map({ (artworks) -> [SectionItem] in
					return zip(artworks, safeResponse).map({ (artwork,playlist) -> SectionItem in
						return SectionItem.FeaturePlaylistSectionItem(viewModel: StagePlaylistFeatureBannerViewModel(playlist: playlist, artwork: artwork))
					})
				})
			}
			return result
		}
		
		let forYouSection = dataResponse.flatMapLatest { [unowned self](response) -> Observable<[SectionItem]?> in
			if let safeResponse = response.forYou{
				return self.dataUsecase.toArtwork(items: safeResponse).map({ (artworks) -> [SectionItem] in
					return zip(artworks, safeResponse).map({ (arg) -> SectionItem in
						
						let (artwork, music) = arg
						return SectionItem.TrackSectionItem(viewModel: CommonSongCellVM(Music: music, artwork: artwork))
					})
				})
			}
			return Observable<[SectionItem]?>.just(nil)
		}
		
		let collections = Observable.combineLatest(forYouSection, bestOfArtistsSection, recentSection, albumSection).map { (forYou, best, recent, album) -> [MultipleSectionModel] in
							return [MultipleSectionModel.FeatureAlbumListSection(title: "Albums", items: album ?? [SectionItem]()),
											MultipleSectionModel.TrackListSection(title: "recently Added", items: recent ?? [SectionItem]()),
											MultipleSectionModel.FeaturePlaylistListSection(title: "Best Of Artists", items: best ?? [SectionItem]()),
											MultipleSectionModel.TrackListSection(title: "Picked For You", items: forYou ?? [SectionItem]())]
						}
		
			
//			dataResponse.flatMapLatest {[unowned self](response) -> Observable<[MultipleSectionModel]> in
//
//			var forYouSection = Observable<[SectionItem]?>.just(nil)
//
//			return recentSection.filter{$0 != nil}.map{$0!}.map({ (sections) -> [MultipleSectionModel] in
//				return [MultipleSectionModel.TrackListSection(title: "ForYou", items: sections)]
//			})
//		}
		let playAction = Driver.combineLatest(input.pickedSelection, recentSection.filter{$0 != nil}.map{$0!}.asDriverOnErrorJustComplete().flatMapLatest{ (items) -> Driver<[Playable]> in
			

			let musics = items.compactMap({ (section) -> Music? in
				if case .TrackSectionItem(let vm) = section {
					return vm.model
				}
				return nil
			})
			return self.dataUsecase.toPlayable(tracks: musics).asDriverOnErrorJustComplete()
		}).do(onNext: { (index,items) in
			self.playerUsecase.setup(models: items, index: index.row)
		}).mapToVoid()
		return Output(isFetching: fetchingTracker.asDriver(), collections: collections.asDriverOnErrorJustComplete(), shouldBlur: shouldBlur, playAction: playAction, error: errorTracker.asDriver())
	}
}
extension PlayStageViewModel {
	struct Input {
		let mainScrollViewContentOffset:Driver<CGPoint>
		let albumSelection: Driver<IndexPath>
		let pickedSelection: Driver<IndexPath>
	}
	
	struct Output {
		let isFetching: Driver<Bool>
		let collections: Driver<[MultipleSectionModel]>
		let shouldBlur: Driver<Bool>
		let playAction: Driver<Void>
		let error: Driver<Error>
	}
}
