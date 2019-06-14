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
    private let services: UseCaseProvider
    init(navigationController: UINavigationController, services: UseCaseProvider) {
        self.navigationController = navigationController
        self.services = services
    }
    
    func setup() {
        let splashVC = SplashScreenController(nibName: "SplashScreenController", bundle: nil)
        splashVC.viewModel = SplashViewModel(navigator: self)
        navigationController.viewControllers = [splashVC]
    }
    
    func toHome() {
			
    }
    
    func toOnboarding() {
    }
    
}
