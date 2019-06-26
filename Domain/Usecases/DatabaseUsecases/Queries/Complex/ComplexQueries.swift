//
//  ComplexQueries.swift
//  Domain
//
//  Created by Behrad Kazemi on 6/25/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import RxSwift
public protocol ComplexQueries {
	
	//	search By Artist
	func getMusics(ofArtist artist: Artist) -> Observable<[Music]>
	func getAlbums(ofArtist artist: Artist) -> Observable<[Album]>
	
	//	search By Album
	func getMusics(ofAlbum album: Album) -> Observable<[Music]>
	func getArtist(ofAlbum album: Album) -> Observable<Artist?>
	
	//	search By Music
	func getPlayable(ofMusic music: Music) -> Observable<Playable?>
	func getAlbum(ofMusic music: Music) -> Observable<Album?>
	func getArtist(ofMusic music: Music) -> Observable<Artist?>
	func getPlaylists(Contains music: Music) -> Observable<[Playlist]>
	
	//	search By Playlist
	func getMusics(ofPlaylist playlist: Playlist) -> Observable<[Music]>
	
	//	search By Collection
	func getPlaylists(ofCollection collection: FeaturedCollections) -> Observable<[Playlist]>
	
	
//	search By Rate
	func getMusics(withRate rate: Double, radius: Double, fromDate: Date) -> Observable<[Music]>
	func getAlbums(withRate rate: Double, radius: Double, fromDate: Date) -> Observable<[Album]>
	func getArtists(withRate rate: Double, radius: Double, fromDate: Date) -> Observable<[Artist]>
}
