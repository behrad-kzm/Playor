//
//  FeatureBannerViewModelProtocol.swift
//  Playor
//
//  Created by Behrad Kazemi on 6/20/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import UIKit
import Domain
protocol FeatureBannerViewModelProtocol {
	typealias T = BannerListType
	var title: String { get }
	var backgroundArtwork: Artwork { get }
	var model: T { get }
}
enum BannerListType {
	typealias playlist = Playlist
	typealias album = Album
}
