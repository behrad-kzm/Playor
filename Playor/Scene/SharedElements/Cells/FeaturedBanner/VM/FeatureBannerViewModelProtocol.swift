//
//  FeatureBannerViewModelProtocol.swift
//  Playor
//
//  Created by Behrad Kazemi on 6/20/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import UIKit
protocol FeatureBannerViewModelProtocol {
	var title: String { get }
	var backgroundImage: UIImage { get }
	func loadImage
}
