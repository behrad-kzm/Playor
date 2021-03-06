//
//  SplashScreenController.swift
//
//  Created by Behrad Kazemi on 12/27/18.
//  Copyright © 2018 Behrad Kazemi. All rights reserved.
//

import UIKit
import NetworkPlatform
import SoundsPlatform
import Domain
import SABlurImageView
class SplashScreenController: UIViewController {
	var viewModel: SplashViewModel!
	
	@IBOutlet weak var byBEKAppsLabel: UILabel!
	@IBOutlet weak var backImageView: SABlurImageView!
	@IBOutlet weak var logoLabel: UILabel!
	override func viewDidLoad() {
		super.viewDidLoad()
		assert(viewModel != nil)
		//[TODO] do some initial works here before entering the app

		logoLabel.alpha = 0
		byBEKAppsLabel.alpha = 0
	}
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		animation {
			
		}
	}
	func setupUI(){
		logoLabel.font = Appearance.Fonts.Special.logo()
	}
	private func animation(completion: @escaping () -> ()){
		backImageView.configrationForBlurAnimation(100)
		backImageView.blur(0.7)
		backImageView.startBlurAnimation(0.5)
		
		Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { [unowned self]_  in
			AppEffectSounds().playSound()
			Vibrator.vibrate(hardness: 6)
			UIView.animate(withDuration: 0.1, animations: {
				self.logoLabel.alpha = 1
			}, completion: { [unowned self](finished) in
				if finished {
					
					Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: { (_) in
						
						UIView.animate(withDuration: 0.1, animations: {
							self.byBEKAppsLabel.alpha = 1
						})
					})
					Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false, block: { (_) in
						self.viewModel.popLoginIfNeededOrContinue {}
					})
					
				}
			})
		}
	}
}
