//
//  SingleTableQueryProvider.swift
//  Domain
//
//  Created by Behrad Kazemi on 7/10/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import RxSwift
public protocol SingleTableQueryProvider {

	func getPlaylistQueries() -> PlaylistQueries
	func getAlbumsQueries() -> AlbumQueries
	func getAtworksQueries() -> ArtworkQueries
	func getArtistQueries() -> ArtistQueries
	func getMusicQueries() -> MusicQueries
}
