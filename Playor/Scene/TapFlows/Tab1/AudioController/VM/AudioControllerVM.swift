//
//  AudioControllerVM.swift
//  Playor
//
//  Created by Behrad Kazemi on 9/5/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Domain
final class AudioControllerVM: ViewModelType {
	
	private let navigator: AudioControllerNavigator
	private let playerUsecase: FullPlayerUsecase
	private let dataUsecase: AudioControllerUseCase
	let playerVM: ACHeaderVM
	
	init(navigator: AudioControllerNavigator, playerUsecase: FullPlayerUsecase, dataUsecase: AudioControllerUseCase, initialArtworkPath: String, title: String, playingStatus: PlayerStatus, currentTime: TimeInterval) {
		self.navigator = navigator
		self.playerUsecase = playerUsecase
		self.dataUsecase = dataUsecase
		self.playerVM = ACHeaderVM(playerUsecase: playerUsecase, dataUsecase: dataUsecase, artowrkPath: initialArtworkPath, title: title, playingStatus: playingStatus, currentTime: currentTime)
	}
	
	func transform(input: Input) -> Output {
		let errorTracker = ErrorTracker()
		let fetchingTracker = ActivityIndicator()
		
		return Output(isFetching: fetchingTracker.asDriver(), error: errorTracker.asDriver())
	}
}
extension AudioControllerVM {
	struct Input {
	}
	
	struct Output {
		let isFetching: Driver<Bool>
		let error: Driver<Error>
	}
}
