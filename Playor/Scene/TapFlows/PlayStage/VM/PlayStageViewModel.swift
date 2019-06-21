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
import NetworkPlatform
import Domain
final class PlayStageViewModel {
	
	private let navigator: PlayStageNavigator
	private let playerUsecase: ToolbarUsecase
	init(navigator: PlayStageNavigator, playerUsecase: ToolbarUsecase) {
		self.navigator = navigator
		self.playerUsecase = playerUsecase
	}
	func popLoginIfNeededOrContinue(handler: @escaping ()->()) {
		navigator.toHome()
	}
}
