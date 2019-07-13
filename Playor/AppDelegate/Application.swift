//
//  Application.swift
//
//  Created by Behrad Kazemi on 11/20/18.
//  Copyright © 2018 Behrad Kazemi. All rights reserved.
//

import Domain
import NetworkPlatform
import SoundsPlatform
import RealmPlatform
import SuggestionPlatform
final class Application {
  static let shared = Application()
  
  private let networkUseCaseProvider: NetworkPlatform.UseCaseProvider
	private let soundsUseCaseProvider: SoundsPlatform.UseCaseProvider
	private let realmUseCaseProvider: RealmPlatform.UseCaseProvider
	private let suggestionUseCaseProvider: SuggestionPlatform.SuggestionUsecaseProvider
  private init() {
    AnalyticProxy.setup()
    self.networkUseCaseProvider = NetworkPlatform.UseCaseProvider()

		self.realmUseCaseProvider = RealmPlatform.UseCaseProvider()
		let manager = realmUseCaseProvider.makeQueryManager()
		self.soundsUseCaseProvider = SoundsPlatform.UseCaseProvider(manager: manager)
		self.suggestionUseCaseProvider = SuggestionPlatform.SuggestionUsecaseProvider(queryManager: realmUseCaseProvider.makeQueryManager())
  }
  
  func configureMainInterface(in window: UIWindow) {
    let mainNavigationController = MainNavigationController()
    window.rootViewController = mainNavigationController
    window.makeKeyAndVisible()
		SplashNavigator(navigationController: mainNavigationController, dataBaseServices: realmUseCaseProvider, services: networkUseCaseProvider, soundServices: soundsUseCaseProvider, suggestion: suggestionUseCaseProvider).setup()
		guard let url = Bundle.main.url(forResource: "Test2", withExtension: "mp3") else { return }
		let useCase = soundsUseCaseProvider.makeAudioFileHandler()
//		useCase.handleNewMusic(url: url)
//		soundsUseCaseProvider.
  }
}

