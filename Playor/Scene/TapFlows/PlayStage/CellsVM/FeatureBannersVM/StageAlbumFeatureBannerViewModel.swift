//
//  StageAlbumFeatureBannerViewModel.swift
//  Playor
//
//  Created by Behrad Kazemi on 6/21/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import UIKit
import Domain

final class StageAlbumFeatureBannerViewModel: FeatureBannerViewModelProtocol {
	typealias T = Album
	let title: String
	let backgroundArtwork: Artwork
	let model: Album
	init(album: Album, artwork: Artwork) {
		self.title = album.title
		self.backgroundArtwork = artwork
		self.model = album
	}
}
