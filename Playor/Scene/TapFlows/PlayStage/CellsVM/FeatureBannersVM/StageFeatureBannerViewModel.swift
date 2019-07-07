//
//  StageFeatureBannerViewModel.swift
//  Playor
//
//  Created by Behrad Kazemi on 6/21/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import UIKit
import Domain
final class StageFeatureBannerViewModel: FeatureBannerViewModelProtocol {
	var title: String
	
	var backgroundImage: UIImage
	

	init(album: Album) {
		self.title = album.title
		self.backgroundImage
	}
}
