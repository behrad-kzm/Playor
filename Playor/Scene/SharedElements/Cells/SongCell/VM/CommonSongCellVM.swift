//
//  CommonSongCellVM.swift
//  Playor
//
//  Created by Behrad Kazemi on 7/8/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import Domain
final class CommonSongCellVM: SongCellViewModelProtocol{

	let title: String
	let backgroundArtwork: Artwork
	let model: Music
	init(Music music: Music, artwork: Artwork) {
		self.title = music.title
		self.model = music
		self.backgroundArtwork = artwork
	}
}
