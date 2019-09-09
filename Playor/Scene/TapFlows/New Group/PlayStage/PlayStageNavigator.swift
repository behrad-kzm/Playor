//
//  PlayStageNavigator.swift
//  Playor
//
//  Created by Behrad Kazemi on 6/17/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import Domain
import NetworkPlatform
import RxCocoa
class PlayStageNavigator {
	
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
	
	
	func toMusicPlayer(currentArtworkPath: String, title: String, playingStatus: PlayerStatus, currentTime: TimeInterval){
		AudioControllerNavigator(services: services, soundServices: soundServices, navigationController: navigationController, dataBaseUsecase: dataBaseUsecase).show(artworkPath: currentArtworkPath, title: title, playingStatus: playingStatus, currentTime: currentTime)
	}
	
	func toCollections(){
		
	}
	
	func toListView(){
		
	}
	
	func toError(error: Error) {
		
	}
	
}
