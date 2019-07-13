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
		let collections = dataUsecase.getDataModel().trackError(errorTracker).trackActivity(fetchingTracker).flatMapLatest {[unowned self](response) -> Observable<[MultipleSectionModel]> in
			var albumSection = Observable<[SectionItem]?>.just(nil)
			var recentSection = Observable<[SectionItem]?>.just(nil)
			var bestOfArtistsSection = Observable<[SectionItem]?>.just(nil)
			var forYouSection = Observable<[SectionItem]?>.just(nil)
			if let safeResponse = response.albums{
				
				albumSection = self.dataUsecase.toArtwork(items: safeResponse).map({ (artworks) -> [SectionItem] in
					return zip(artworks, safeResponse).map({ (artwork, album) -> SectionItem in
						return SectionItem.FeatureAlbumSectionItem(viewModel: StageAlbumFeatureBannerViewModel(album: album, artwork: artwork))
					})
				})
			}
			if let safeResponse = response.recent {
				recentSection = self.dataUsecase.toArtwork(items: safeResponse).map({ (artworks) -> [SectionItem] in
					return zip(artworks, safeResponse).map({ (artwork,music) -> SectionItem in
						return SectionItem.TrackSectionItem(viewModel: CommonSongCellVM(Music: music, artwork: artwork))
					})
				})
			}
			if let safeResponse = response.bestOfArtists{
				bestOfArtistsSection = self.dataUsecase.toArtwork(items: safeResponse).map({ (artworks) -> [SectionItem] in
					return zip(artworks, safeResponse).map({ (artwork,playlist) -> SectionItem in
						return SectionItem.FeaturePlaylistSectionItem(viewModel: StagePlaylistFeatureBannerViewModel(playlist: playlist, artwork: artwork))
					})
				})
			}
			if let safeResponse = response.forYou{
				forYouSection = self.dataUsecase.toArtwork(items: safeResponse).map({ (artworks) -> [SectionItem] in
					return zip(artworks, safeResponse).map({ (arg) -> SectionItem in
						
						let (artwork, music) = arg
						return SectionItem.TrackSectionItem(viewModel: CommonSongCellVM(Music: music, artwork: artwork))
					})
				})
			}
			return albumSection.filter{$0 != nil}.map{$0!}.map({ (sections) -> [MultipleSectionModel] in
				return [MultipleSectionModel.FeatureAlbumListSection(title: "Albums", items: sections)]
			})
			//			return Observable.combineLatest(albumSection,recentSection,bestOfArtistsSection,forYouSection).map({ (albums,recents,bestsOfArtists,forYou) -> [MultipleSectionModel] in
			//				return [MultipleSectionModel.FeatureAlbumListSection(title: "Albums", items: albums),
			//								MultipleSectionModel.TrackListSection(title: "recently Added", items: recents),
			//								MultipleSectionModel.FeaturePlaylistListSection(title: "Best Of Artists", items: bestsOfArtists),
			//								MultipleSectionModel.TrackListSection(title: "Picked For You", items: forYou)]
			//			})
		}
		return Output(isFetching: fetchingTracker.asDriver(), collections: collections.asDriverOnErrorJustComplete(), shouldBlur: shouldBlur, error: errorTracker.asDriver())
	}
}
extension PlayStageViewModel {
	struct Input {
		let mainScrollViewContentOffset:Driver<CGPoint>
		let albumSelection: Driver<IndexPath>
	}
	
	struct Output {
		let isFetching: Driver<Bool>
		let collections: Driver<[MultipleSectionModel]>
		let shouldBlur: Driver<Bool>
		let error: Driver<Error>
	}
}
