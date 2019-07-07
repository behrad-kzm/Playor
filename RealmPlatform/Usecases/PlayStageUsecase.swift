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
	public init(suggestion: Domain.SuggestionUsecase){
		self.suggestion = suggestion
	}
	
	public func getDataModel() -> Observable<PlayStageDataModel.Response> {
		
		let albums = suggestion.getAlbums()
		let playlistForUser = suggestion.suggestWellRandomizedPlaylist()
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
	
}
