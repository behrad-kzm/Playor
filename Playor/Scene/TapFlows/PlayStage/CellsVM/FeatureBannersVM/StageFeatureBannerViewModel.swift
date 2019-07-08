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
	let album: Album
	let artwork: Artwork
	init(album: Album, artwork: Artwork) {
		self.title = album.title
		self.backgroundImage = UIImage(
	}
}
