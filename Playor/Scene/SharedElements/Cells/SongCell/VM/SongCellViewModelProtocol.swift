//
//  SongCellViewModelProtocol.swift
//  Playor
//
//  Created by Behrad Kazemi on 6/21/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import UIKit
import Domain
protocol SongCellViewModelProtocol {
	var title: String { get }
	var backgroundArtwork: Artwork { get }
	var model: Music { get }
}
