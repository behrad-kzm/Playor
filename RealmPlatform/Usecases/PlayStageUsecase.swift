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
import MediaPlayer
public final class PlayStageUsecase: Domain.PlayStageUsecase {
	
	private let suggestion: Domain.SuggestionUsecase
	private let musicHandler: Domain.AudioFileHandler

	private let getMusics: (_ playlist: Playlist?) -> Observable<[Music]>
	private let getMusicsOfPlayable: (_ playable: Playable) -> Observable<[Music]>
	private let getPlayables: (_ musics: [Music]) -> Observable<[Playable]>
	private let getArtworks: (_ artworks: [ArtworkContainedProtocol]) -> Observable<[Artwork]>
	public init(suggestion: Domain.SuggestionUsecase, autioFileHandler: Domain.AudioFileHandler, musicQuery: @escaping (_ playlist: Playlist) -> Observable<[Music]>, artworkQuery: @escaping  (_ artworks: [ArtworkContainedProtocol]) -> Observable<[Artwork]>, playableQuery: @escaping (_ musics: [Music]) -> Observable<[Playable]>, musicFromPlayable: @escaping (_ playable: Playable) -> Observable<[Music]>){
		self.suggestion = suggestion
		self.getMusics = {(item: Playlist?) -> Observable<[Music]> in
			if let safeParameter = item {
				return musicQuery(safeParameter)
			}
			return Observable.just([Music]())
		}
		self.getMusicsOfPlayable = musicFromPlayable
		self.musicHandler = autioFileHandler
		self.getArtworks = artworkQuery
		self.getPlayables = playableQuery
	}

	
	public func getDataModel() -> Observable<PlayStageDataModel.Response> {
		let albums = suggestion.getAlbums().map{Optional.some($0) }
		let playlistForUser = suggestion.suggestWellRandomizedPlaylist().filter{$0 != nil}.flatMapLatest { [unowned self](playlist) -> Observable<[Music]> in
			return self.getMusics(playlist)
			}.map{Optional.some($0) }.startWith(nil)

		let greatestHitsOfArtists = suggestion.suggestTopArtists().flatMapLatest{ [unowned self](artists) -> Observable<[Playlist]> in
			let playlistArray = artists.map({ (artist) -> Observable<Playlist> in
				return self.suggestion.suggestWellRandomizedPlaylist(byArtist: artist).filter({ (playlist) -> Bool in
					playlist != nil
				}).map{ $0!}
			})
			return Observable.zip(playlistArray)
			}.map{Optional.some($0) }.startWith(nil)
		let recentlyMusics = suggestion.suggestRecentMusics().map{Optional.some($0) }.startWith(nil)
		
		let response = Observable.combineLatest(albums, playlistForUser, recentlyMusics, greatestHitsOfArtists).map { (arg) -> PlayStageDataModel.Response in
			let (albums, forYou, recent, greatestHits) = arg
			return PlayStageDataModel.Response(albums: albums, forYou: forYou, recent: recent, bestOfArtists: greatestHits)
		}
		return response.takeLast(1).share(replay: 1, scope: .forever)
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
		let result = getPlayables(tracks)
		return result.map { (playables) -> [Playable] in
			return tracks.compactMap({ (item) -> Playable? in
				return playables.filter{$0.uid == item.playableID}.first
			})
		}
	}
	
	public func toMusic(item: Playable) -> Observable<Music> {
		let result = getMusicsOfPlayable(item).filter{$0.count > 0}.map{$0.first!}
		return result
	}
	
	public func toArtwork(items: [ArtworkContainedProtocol]) -> Observable<[Artwork]> {
		let result = getArtworks(items)
		return result.map { (artworks) -> [Artwork] in
			return items.compactMap({ (item) -> Artwork? in
				return artworks.filter{$0.uid == item.artworkID}.first
			})
		}
	}
	
	public func checkITunes() -> Observable<Void>{
		if MPMediaLibrary.authorizationStatus() == .authorized {
			
			if let itunesSongs = MPMediaQuery.songs().items?.compactMap({ (item) -> Observable<Void>? in
				guard let itemURL = item.assetURL else{
					return nil
				}
				return musicHandler.handleNewItunesMusic(url: itemURL).take(1).share(replay: 1, scope: .forever)
			}){
				return Observable.concat(itunesSongs)
			}
		}
		return Observable.just(())
	}
}
