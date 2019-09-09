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
	private let dataBaseUsecase: Domain.DataBaseUsecaseProvider
	init(services: Domain.NetworkUseCaseProvider, soundServices: Domain.SoundUsecaseProvider, navigationController: UINavigationController, dataBaseUsecase: Domain.DataBaseUsecaseProvider) {
		self.services = services
		self.soundServices = soundServices
		self.navigationController = navigationController
		self.dataBaseUsecase = dataBaseUsecase
	}
	
	func show(artworkPath: String, title: String, playingStatus: PlayerStatus, currentTime: TimeInterval) {
		let viewController = AudioControllerViewController(nibName: "AudioControllerViewController", bundle: nil)
		viewController.viewModel = AudioControllerVM(navigator: self, playerUsecase: soundServices.makeFullPlayerUsecase(), dataUsecase: dataBaseUsecase.makeAudioControllerUseCase(), initialArtworkPath: artworkPath, title: title, playingStatus: playingStatus, currentTime: currentTime)
		viewController.loadView()
		viewController.view.layoutIfNeeded()
		viewController.view.layoutSubviews()
		
		viewController.setupUI()
		if let current = navigationController.viewControllers.last{
			viewController.modalPresentationStyle = .overCurrentContext
			current.present(viewController, animated: true, completion: nil)
		}
	}
	
	func toHome(){
		navigationController.popViewController(animated: true)
	}
	
	func toError(error: Error) {
		
	}
	
}
