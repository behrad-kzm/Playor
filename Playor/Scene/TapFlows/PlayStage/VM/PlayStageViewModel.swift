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
		let collections = dataUsecase.getDataModel().trackError(errorTracker).trackActivity(fetchingTracker).flatMapLatest {[unowned self](response) -> Observable<[MultipleSectionModel]> in
			let albumSection = self.dataUsecase.toArtwork(items: response.albums).map({ (artworks) -> [SectionItem] in
				return zip(artworks, response.albums).map({ (artwork, album) -> SectionItem in
					return SectionItem.FeatureSectionItem(viewModel: StageAlbumFeatureBannerViewModel(album: album, artwork: artwork))
				})
			})
			
			let recentSection = self.dataUsecase.toArtwork(items: response.recent).map({ (artworks) -> [SectionItem] in
				return zip(artworks, response.recent).map({ (artwork,music) -> SectionItem in
					return SectionItem.TrackSectionItem(viewModel: CommonSongCellVM(Music: music, artwork: artwork))
				})
			})
			
			let bestOfArtistsSection = self.dataUsecase.toArtwork(items: response.bestOfArtists).map({ (artworks) -> [SectionItem] in
				return zip(artworks, response.bestOfArtists).map({ (artwork,playlist) -> SectionItem in
					return SectionItem.FeatureSectionItem(viewModel: StagePlaylistFeatureBannerViewModel(playlist: playlist, artwork: artwork))
				})
			})
			var sections = Observable.combineLatest(albumSection,recentSection,bestOfArtistsSection).map({ (albums,recents,bestsOfArtists) -> [MultipleSectionModel] in
				return [MultipleSectionModel.FeatureListSection(title: "Albums", items: albums),
									 MultipleSectionModel.TrackListSection(title: "recently Added", items: recents),
									 MultipleSectionModel.FeatureListSection(title: "Best Of Artists", items: bestsOfArtists)]
			})
			if let forYouPlaylist = response.forYou {
				let forYouSection = self.dataUsecase.toArtwork(items: forYouPlaylist).map({ (artworks) -> [SectionItem] in
					return zip(artworks, forYouPlaylist).map({ (artwork,playlist) -> SectionItem in
						return SectionItem.FeatureSectionItem(viewModel: StagePlaylistFeatureBannerViewModel(playlist: playlist, artwork: artwork))
					})
				})
				
				return sections.map({ (items) -> [MultipleSectionModel] in
					var resultArray = items
					resultArray.append(MultipleSectionModel.TrackListSection(title: "Picked For You", items: <#T##[SectionItem]#>))
				})
			}
			return
		}
		return Output(isFetching: fetchingTracker.asDriver(), collections: collections.asDriverOnErrorJustComplete(), error: errorTracker.asDriver())
	}
}
extension PlayStageViewModel {
	struct Input {
		let itemSelection: Driver<IndexPath>
	}
	
	struct Output {
		let isFetching: Driver<Bool>
		let collections: Driver<[MultipleSectionModel]>
		let error: Driver<Error>

	}
}
