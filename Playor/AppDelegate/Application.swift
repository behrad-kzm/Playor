//
//  Application.swift
//
//  Created by Behrad Kazemi on 11/20/18.
//  Copyright © 2018 Behrad Kazemi. All rights reserved.
//

import NetworkPlatform
import Domain
final class Application {
  static let shared = Application()
  
  private let networkUseCaseProvider: NetworkPlatform.UseCaseProvider
  private init() {
    AnalyticProxy.setup()
    self.networkUseCaseProvider = NetworkPlatform.UseCaseProvider()
  }
  
  func configureMainInterface(in window: UIWindow) {
    let mainNavigationController = MainNavigationController()
    window.rootViewController = mainNavigationController
    window.makeKeyAndVisible()
    
    SplashNavigator(navigationController: mainNavigationController, services: networkUseCaseProvider).setup()
  }

}

