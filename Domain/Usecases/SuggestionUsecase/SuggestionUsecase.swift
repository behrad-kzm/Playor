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
	
	func suggest(CollectionByOption option: QueryOptions) -> Observable<[FeaturedCollections]>
	func suggest(PlaylistByOption option: QueryOptions) -> Observable<[Playlist]>
	func suggest(PlaylistByOption option: QueryOptions, byArtist artist: Artist) -> Observable<[Playlist]>
	func suggest(ArtistByOption option: QueryOptions) -> Observable<[Artist]>
	func suggest(AlbumsByOption option: QueryOptions) -> Observable<[Album]>
	func suggest(AlbumsByOption option: QueryOptions, byArtist artist: Artist) -> Observable<[Album]>
	func suggest(MusicByOption option: QueryOptions) -> Observable<[Music]>
}
