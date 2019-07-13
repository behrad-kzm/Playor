//
//  MainTabbarNavigator.swift
//
//  Created by Behrad Kazemi on 1/26/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import Domain
class MainTabbarNavigator {
  
  private let navigationController: UINavigationController
  private let tabbarVC: UITabBarController
  private let services: Domain.NetworkUseCaseProvider
	private let soundServices: Domain.SoundUsecaseProvider
	private let dataBaseUsecase: Domain.DataBaseUsecaseProvider
	private let suggestion: Domain.SuggestionUsecase
	init(services: Domain.NetworkUseCaseProvider, dataBaseUsecase: Domain.DataBaseUsecaseProvider, soundServices: Domain.SoundUsecaseProvider, navigationController: UINavigationController, tabbar: UITabBarController, suggestion: Domain.SuggestionUsecase) {
    self.navigationController = navigationController
    self.tabbarVC = tabbar
    self.services = services
		self.soundServices = soundServices
		self.dataBaseUsecase = dataBaseUsecase
		self.suggestion = suggestion
  }
  
  func setup(withIndex index: Int = 0) {
		
		let tabbar = tabbarVC.tabBar

		tabbar.layer.borderWidth = 0.50
		tabbar.layer.borderColor = UIColor.clear.cgColor
		tabbar.clipsToBounds = true
		navigationController.modalTransitionStyle = .crossDissolve
		navigationController.pushViewController(tabbarVC, animated: true)
		tabbar.backgroundImage = UIImage()
		
		let lineView = UIView(frame: CGRect(x: 0, y: 0, width: tabbar.frame.size.width, height: 0.5))
		lineView.backgroundColor = .white
		lineView.alpha = 0.5
		tabbar.addSubview(lineView)
		
		
		
		let playStageNavigator = PlayStageNavigator(services: services, soundServices: soundServices, navigationController: navigationController)
		let playStageViewModel = PlayStageViewModel(navigator: playStageNavigator, playerUsecase: soundServices.makeToolbarUsecase(), dataUsecase: dataBaseUsecase.makePlayStageUseCase(suggestion: suggestion))
		let playStageViewController = PlayStageViewController(nibName: "PlayStageViewController", bundle: nil)
		playStageViewController.viewModel = playStageViewModel
		
		tabbarVC.viewControllers = [playStageViewController]
		
		let tabHome = tabbar.items![0]
		tabHome.title = ""
		tabHome.image = UIImage(named: "Home-TabIcon") // deselect image
		tabHome.selectedImage = UIImage(named: "Home-TabIcon-Selected") // select image
		
  }
  
  func toIndex(index: Int){
    tabbarVC.selectedIndex = index
  }
}
