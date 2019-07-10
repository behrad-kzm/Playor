//
//  StagePlaylistFeatureBannerViewModel.swift
//  Playor
//
//  Created by Behrad Kazemi on 7/9/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import UIKit
import Domain

final class StagePlaylistFeatureBannerViewModel: FeatureBannerViewModelProtocol {
	typealias T = Playlist
	let title: String
	let backgroundArtwork: Artwork
	let model: Playlist
	init(playlist: Playlist, artwork: Artwork) {
		self.title = playlist.title
		self.backgroundArtwork = artwork
		self.model = playlist
	}
}
