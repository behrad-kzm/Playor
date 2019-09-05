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
			return point.y > -100 ? true : false
		}
		let dataResponse = dataUsecase.getDataModel().trackError(errorTracker).trackActivity(fetchingTracker)
		
		let albumSection = dataResponse.flatMapLatest { [dataUsecase](response) -> Observable<[SectionItem]?> in
				var result = Observable<[SectionItem]?>.just(nil)
			if let safeResponse = response.albums{
				result = dataUsecase.toArtwork(items: safeResponse).map({ (artworks) -> [SectionItem] in
					return zip(artworks, safeResponse).map({ (artwork, album) -> SectionItem in
						return SectionItem.FeatureAlbumSectionItem(viewModel: StageAlbumFeatureBannerViewModel(album: album, artwork: artwork))
					})
				})
			}
			return result
		}.takeLast(1).share(replay: 1, scope: .forever)
		
		let recentSection = dataResponse.flatMapLatest { [dataUsecase](response) -> Observable<[SectionItem]?> in
			if let safeResponse = response.recent {
				return dataUsecase.toArtwork(items: safeResponse).map({ (artworks) -> [SectionItem] in
					
					return zip(artworks, safeResponse).map({ (artwork,music) -> SectionItem in
						return SectionItem.TrackSectionItem(viewModel: CommonSongCellVM(Music: music, artwork: artwork))
					})
				})
			}
			return Observable<[SectionItem]?>.just(nil)
			}.takeLast(1).share(replay: 1, scope: .forever)
		
		let bestOfArtistsSection = dataResponse.flatMapLatest { [dataUsecase](response) -> Observable<[SectionItem]?> in
			var result = Observable<[SectionItem]?>.just(nil)
			if let safeResponse = response.bestOfArtists{
				result = dataUsecase.toArtwork(items: safeResponse).map({ (artworks) -> [SectionItem] in
					return zip(artworks, safeResponse).map({ (artwork,playlist) -> SectionItem in
						return SectionItem.FeaturePlaylistSectionItem(viewModel: StagePlaylistFeatureBannerViewModel(playlist: playlist, artwork: artwork))
					})
				})
			}
			return result
		}.take(1).share(replay: 1, scope: .forever)
		
		let forYouSection = dataResponse.flatMapLatest { [dataUsecase](response) -> Observable<[SectionItem]?> in
			
			if let safeResponse = response.forYou{
				return dataUsecase.toArtwork(items: safeResponse).map({ (artworks) -> [SectionItem] in
					
					return zip(artworks, safeResponse).map({ (arg) -> SectionItem in
						
						let (artwork, music) = arg
						print("\nartwork uid: \(artwork.uid) \n --music artwork uid: \(music.artworkID)")
						return SectionItem.TrackSectionItem(viewModel: CommonSongCellVM(Music: music, artwork: artwork))
					})
				})
			}
			return Observable<[SectionItem]?>.just(nil)
		}.takeLast(1).share(replay: 1, scope: .forever)
		
		let collections = Observable.zip(forYouSection, bestOfArtistsSection, recentSection, albumSection).map { (forYou, best, recent, album) -> [MultipleSectionModel] in
							return [MultipleSectionModel.FeatureAlbumListSection(title: "Albums", items: album ?? [SectionItem]()),
											MultipleSectionModel.TrackListSection(title: "recently Added", items: recent ?? [SectionItem]()),
											MultipleSectionModel.FeaturePlaylistListSection(title: "Best Of Artists", items: best ?? [SectionItem]()),
											MultipleSectionModel.TrackListSection(title: "Picked For You", items: forYou ?? [SectionItem]())]
						}
		let selectFromForYouSection = Driver.combineLatest(input.pickedSelection, forYouSection.filter{$0 != nil}.map{$0!}.asDriverOnErrorJustComplete().flatMapLatest{ [dataUsecase] (items) -> Driver<[Playable]> in
			
			let musics = items.compactMap({ (section) -> Music? in
				if case .TrackSectionItem(let vm) = section {
					return vm.model
				}
				return nil
			})
			
			return dataUsecase.toPlayable(tracks: musics).asDriverOnErrorJustComplete()
		})
		let selectFromRecentSection = Driver.combineLatest(input.recentSelection, recentSection.filter{$0 != nil}.map{$0!}.asDriverOnErrorJustComplete().flatMapLatest{ [dataUsecase] (items) -> Driver<[Playable]> in
			
			let musics = items.compactMap({ (section) -> Music? in
				if case .TrackSectionItem(let vm) = section {
					return vm.model
				}
				return nil
			})
			
			return dataUsecase.toPlayable(tracks: musics).asDriverOnErrorJustComplete()
		})
		let checkLibrary = dataUsecase.checkITunes().share(replay: 1, scope: .forever)
		let playAction = Driver.merge(selectFromForYouSection, selectFromRecentSection).do(onNext: { [unowned self](index,items) in
			self.playerUsecase.setup(models: items, index: index.row)
		}).mapToVoid()
		
		let sizes = collections.map { (sections) -> [Float] in
			return sections.compactMap({ (item) -> Float in
				return Float(item.items.count * 64)
			})
		}
		let current = playerUsecase.getCurrent().filter{$0 != nil}.map{$0!}
		let currentMusic = current.flatMapLatest ({ [dataUsecase](playable) -> Observable<Music> in
			return dataUsecase.toMusic(item: playable)
		}).share(replay: 1, scope: .forever)
		
		let artowrkACPath = currentMusic.flatMapLatest({ [dataUsecase](music) -> Observable<Artwork> in
			return dataUsecase.toArtwork(items: [music]).filter{$0.count > 0}.map{$0.first!}
		}).map({ (artwork) -> String in
			return artwork.dataPath
		}).share(replay: 1, scope: .forever).asDriverOnErrorJustComplete()

		let currentSongTitle = currentMusic.map { (music) -> String in
			music.title + " - " + music.artistName
		}.asDriverOnErrorJustComplete()
		
		let showController = playAction.map { (_) -> Bool in
			return true
		}.startWith(false)
		let status = playerUsecase.getStatus().asDriverOnErrorJustComplete()
		let playpause = input.playPause.withLatestFrom(status)
		let pauseAction = playpause.filter{$0 == .playing}.do(onNext: { [playerUsecase](_) in
			playerUsecase.pause()
		})
		let resumeAction = playpause.filter{$0 != .playing}.do(onNext: { [playerUsecase](_) in
			playerUsecase.resume()
		})
		let playPauseAction = Driver.merge(resumeAction, pauseAction).asSharedSequence()
		let playNext = input.next.do(onNext: { [playerUsecase]() in
			playerUsecase.next()
		}).asDriver()
		let playPrevious = input.previous.do(onNext: { [playerUsecase]() in
			playerUsecase.previous()
		}).asDriver()
		
		let forward = input.forward.do(onNext: { [playerUsecase]() in
			playerUsecase.seekForward(duration: 1)
		}).asDriver()
		
		let backward = input.backward.do(onNext: { [playerUsecase]() in
			playerUsecase.seekBakward(duration: 1)
		}).asDriver()
		return Output(isFetching: fetchingTracker.asDriver(), checkITunes: checkLibrary, collections: collections.asDriverOnErrorJustComplete(), collectionHeights: sizes.asDriverOnErrorJustComplete(), shouldBlur: shouldBlur, playAction: playAction, playPause: playPauseAction, next: playNext, forward: forward, previous: playPrevious, backward: backward, showController: showController, artworkACPath: artowrkACPath, songTitleAC: currentSongTitle, error: errorTracker.asDriver())
	}
}
extension PlayStageViewModel {
	struct Input {
		let mainScrollViewContentOffset:Driver<CGPoint>
		let albumSelection: Driver<IndexPath>
		let pickedSelection: Driver<IndexPath>
		let recentSelection: Driver<IndexPath>
		
		let playPause: Driver<Void>
		let next: Driver<Void>
		let previous: Driver<Void>
		let forward: Driver<Void>
		let backward: Driver<Void>
		let openController: Driver<Void>
	}
	
	struct Output {
		let isFetching: Driver<Bool>
		let checkITunes: Observable<Void>
		let collections: Driver<[MultipleSectionModel]>
		let collectionHeights: Driver<[Float]>
		let shouldBlur: Driver<Bool>
		let playAction: Driver<Void>
		let playPause: Driver<PlayerStatus>
		let next: Driver<Void>
		let forward: Driver<Void>
		let previous: Driver<Void>
		let backward: Driver<Void>
		let showController: Driver<Bool>
		let artworkACPath: Driver<String>
		let songTitleAC: Driver<String>
		let error: Driver<Error>
	}
}
