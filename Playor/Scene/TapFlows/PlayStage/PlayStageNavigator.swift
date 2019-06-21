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
	
	init(services: Domain.NetworkUseCaseProvider, soundServices: Domain.SoundUsecaseProvider, navigationController: UINavigationController) {
		self.services = services
		self.soundServices = soundServices
		self.navigationController = navigationController
	}
	
	func toHome(){
		
	}
	
	func toMusicPlayer(){
		
	}
	
	func toCollections(){
		
	}
	
	func toListView(){
		
	}
	
	func toError(error: Error) {
		
	}
	
}
