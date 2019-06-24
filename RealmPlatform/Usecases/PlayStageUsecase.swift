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
		
		let albums = suggestion.suggest(AlbumsByOption: .all)
		let playlistForUser = suggestion.suggest(PlaylistByOption: .wellRandom).map{$0.first}
		let greatestHitsOfArtists = suggestion.suggest(ArtistByOption: .best).flatMapLatest { (artists) -> Observable<[Playlist]> in
			let playlistArray =  artists.map({ (artist) -> Observable<Playlist> in
				return self.suggestion.suggest(PlaylistByOption: .best, byArtist: artist).map{$0.first}.filter{$0 != nil}.map{$0!}
			})
			let merged = Observable.combineLatest(playlistArray) { $0 }
			return merged
		}
    let recentlyMusics = suggestion.suggest(MusicByOption: .recent)
		let response = Observable.combineLatest(albums, playlistForUser, recentlyMusics, greatestHitsOfArtists).map { (arg) -> PlayStageDataModel.Response in
			
			let (albums, forYou, recent, greatestHits) = arg
			return PlayStageDataModel.Response(albums: albums, forYou: forYou, recent: recent, bestOfArtists: greatestHits)
		}
		return response
	}
	
	public func track(music: Music) -> Observable<Void> {
		<#code#>
	}
	
	public func track(playlist: Playlist) -> Observable<Void> {
		<#code#>
	}
	
	public func track(album: Album) -> Observable<Void> {
		<#code#>
	}
	
	public func track(collection: FeaturedCollections) -> Observable<Void> {
		<#code#>
	}
	
}
