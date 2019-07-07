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
		let collections = dataUsecase.getDataModel().map {(response) -> [MultipleSectionModel] in
			let albums = response.albums.compactMap({ (albumItem) -> SectionItem in
				SectionItem.FeatureSectionItem(viewModel: StageFeatureBannerViewModel(album: albumItem))
			})
			let albumsFeature = MultipleSectionModel.FeatureListSection(title: "Albums", items: [SectionItem])
		}
		return Output(isFetching: <#T##Driver<Bool>#>, collections: <#T##Driver<[MultipleSectionModel]>#>, error: <#T##Driver<Error>#>)
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
