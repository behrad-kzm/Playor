//
//  IOManager.swift
//  Domain
//
//  Created by Behrad Kazemi on 6/28/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import RxSwift
public protocol IOManager {
	
	func insert(Playlist playlist: Playlist, TrackIDS trackIDS: [String], Artwork artwork: Artwork) -> Observable<Void>
	func insert(Album album: Album, Artwork artwork: Artwork) -> Observable<Void>
	func insert(Artist artist: Artist, Artwork artwork: Artwork) -> Observable<Void>
	func insert(Music music: Music, PlayableModel playable: Playable, Artwork artwork: Artwork) -> Observable<Void>
	func insert(Music music: Music,ToPlaylist playlist: Playlist) -> Observable<Void>
	func insert(FeaturedCollection collection: FeaturedCollections, Playlists playlists: [Playlist]) -> Observable<Void>
	func getMusicCount() -> Int
	func remove(Playlist playlist: Playlist) -> Observable<Void>
	func remove(Album album: Album) -> Observable<Void>
	func remove(Music music: Music) -> Observable<Void>
	func remove(Artwork artwork: Artwork) -> Observable<Void>
	func replaceWithDefault(Artwork artwork: Artwork, type: ArtworkPlaceholderType) -> Observable<Void>
}
