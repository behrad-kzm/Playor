//
//  SuggestionUsecase.swift
//  Domain
//
//  Created by Behrad Kazemi on 6/22/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import RxSwift

public protocol SuggestionUsecase {
	
	func suggestCollection() -> Observable<FeaturedCollections>
	func suggestWellRandomizedPlaylist() -> Observable<Playlist?>
	func suggestWellRandomizedPlaylist(byArtist artist: Artist) -> Observable<Playlist?>
	func suggestTopArtists() -> Observable<[Artist]>

	func suggestRecentMusics() -> Observable<[Music]>
	func getAlbums() -> Observable<[Album]>
	func getAlbums(byArtist artist: Artist) -> Observable<[Album]>
}
