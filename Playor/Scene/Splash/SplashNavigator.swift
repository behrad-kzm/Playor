//
//  SplashNavigator.swift
//
//  Created by Behrad Kazemi on 12/29/18.
//  Copyright © 2018 Behrad Kazemi. All rights reserved.
//

import Foundation
import Domain
class SplashNavigator {
	
	private let navigationController: UINavigationController
	private let services: NetworkUseCaseProvider
	private let soundServices: SoundUsecaseProvider
	private let dataServices: DataBaseUsecaseProvider
	private let suggestion: SuggestionUsecase
	init(navigationController: UINavigationController,dataBaseServices: DataBaseUsecaseProvider, services: NetworkUseCaseProvider, soundServices: SoundUsecaseProvider, suggestion: SuggestionUsecase) {
		self.navigationController = navigationController
		self.services = services
		self.soundServices = soundServices
		self.dataServices = dataBaseServices
		self.suggestion = suggestion
	}
	
	func setup() {
		let splashVC = SplashScreenController(nibName: "SplashScreenController", bundle: nil)
		splashVC.viewModel = SplashViewModel(navigator: self)
		navigationController.viewControllers = [splashVC]
	}
	
	func toHome() {
		let tabbar = UITabBarController()
		MainTabbarNavigator(services: services, dataBaseUsecase: dataServices, soundServices: soundServices, navigationController: navigationController, tabbar: tabbar, suggestion: suggestion).setup()
	}
	
	func toOnboarding() {
		//		OnboardingNavigator(navigationController: navigationController, services: services).setup()
	}
	
}
