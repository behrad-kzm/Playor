//
//  PlayStageUsecase.swift
//  RealmPlatform
//
//  Created by Behrad Kazemi on 6/23/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import RxSwift
import Domain

public final class PlayStageUsecase: Domain.PlayStageUsecase {

	private let suggestion: Domain.SuggestionUsecase
	private let getMusics: (_ playlist: Playlist) -> Observable<[Music]>
	private let getPlayables: (_ musics: [Music]) -> Observable<[Playable]>
	private let getArtworks: (_ artworks: [ArtworkContainedProtocol]) -> Observable<[Artwork]>
	public init(suggestion: Domain.SuggestionUsecase, musicQuery: @escaping (_ playlist: Playlist) -> Observable<[Music]>, artworkQuery: @escaping  (_ artworks: [ArtworkContainedProtocol]) -> Observable<[Artwork]>, playableQuery: @escaping (_ musics: [Music]) -> Observable<[Playable]>){
		self.suggestion = suggestion
		self.getMusics = musicQuery
		self.getArtworks = artworkQuery
		self.getPlayables = playableQuery
	}
	
	public func getDataModel() -> Observable<PlayStageDataModel.Response> {
		
		let albums = suggestion.getAlbums()
		let playlistForUser = suggestion.suggestWellRandomizedPlaylist().flatMapLatest { [unowned self](playlist) -> Observable<[Music]> in
			return self.getMusics(playlist)
		}
		let greatestHitsOfArtists = suggestion.suggestTopArtists().flatMapLatest { (artists) -> Observable<[Playlist]> in
			let playlistArray =  artists.map({ (artist) -> Observable<Playlist> in
				return self.suggestion.suggestWellRandomizedPlaylist(byArtist: artist)
			})
			let merged = Observable.combineLatest(playlistArray) { $0 }
			return merged
		}
    let recentlyMusics = suggestion.suggestRecentMusics()
		
		let response = Observable.combineLatest(albums, playlistForUser, recentlyMusics, greatestHitsOfArtists).map { (arg) -> PlayStageDataModel.Response in
			
			let (albums, forYou, recent, greatestHits) = arg
			return PlayStageDataModel.Response(albums: albums, forYou: forYou, recent: recent, bestOfArtists: greatestHits)
		}
		return response
	}
	
	public func track(music: Music) -> Observable<Void> {
		return Observable.just(())
	}
	
	public func track(playlist: Playlist) -> Observable<Void> {
		return Observable.just(())
	}
	
	public func track(album: Album) -> Observable<Void> {
		return Observable.just(())
	}
	
	public func track(collection: FeaturedCollections) -> Observable<Void> {
		return Observable.just(())
	}
	
	public func toPlayable(tracks: [Music]) -> Observable<[Playable]> {
		return getPlayables(tracks)
	}
	
	public func toArtwork(items: [ArtworkContainedProtocol]) -> Observable<[Artwork]> {
		return getArtworks(items)
	}
}
