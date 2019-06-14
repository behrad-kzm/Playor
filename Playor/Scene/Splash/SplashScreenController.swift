//
//  SplashScreenController.swift
//  BarandehShow
//
//  Created by Behrad Kazemi on 12/27/18.
//  Copyright © 2018 Behrad Kazemi. All rights reserved.
//

import UIKit
import NetworkPlatform
class SplashScreenController: UIViewController {
  var viewModel: SplashViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        assert(viewModel != nil)
        //[TODO] do some initial works here before entering the app
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
          viewModel.popLoginIfNeededOrContinue(handler: {})
    }
  private func animation(completion: @escaping () -> ()){
        Vibrator.vibrate(hardness: 4)
    }
}

