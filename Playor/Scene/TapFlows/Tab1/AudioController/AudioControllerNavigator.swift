//
//  AudioControllerNavigator.swift
//  Playor
//
//  Created by Behrad Kazemi on 9/5/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import Domain
import NetworkPlatform
import RxCocoa
class AudioControllerNavigator {
	
	private let navigationController: UINavigationController
	private let services: Domain.NetworkUseCaseProvider
	private let soundServices: Domain.SoundUsecaseProvider
	
	init(services: Domain.NetworkUseCaseProvider, soundServices: Domain.SoundUsecaseProvider, navigationController: UINavigationController) {
		self.services = services
		self.soundServices = soundServices
		self.navigationController = navigationController
	}
	
	func show() {
		let viewController = AudioControllerViewController(nibName: "AudioControllerViewController", bundle: nil)
		viewController.viewModel = AudioControllerVM(navigator: self, playerUsecase: soundServices.makeFullPlayerUsecase())
		navigationController.pushViewController(viewController, animated: true)
	}
	
	func toHome(){
		navigationController.popViewController(animated: true)
	}
	
	func toError(error: Error) {
		
	}
	
}
