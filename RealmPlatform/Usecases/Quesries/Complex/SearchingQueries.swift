//
//  SearchingQueries.swift
//  RealmPlatform
//
//  Created by Behrad Kazemi on 7/10/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import RxSwift
import RxRealm
import Domain

public final class SearchingQueries: Domain.SearchingQueries {
	
	private let configuration: Realm.Configuration
	private let scheduler: RunLoopThreadScheduler
	private let disposeBag = DisposeBag()
	private let setupArtworks = "com.bekapps.storagekeys.Setup.Artworks"
	private var realm: Realm {
		return try! Realm(configuration: self.configuration)
	}
	
	init(configuration: Realm.Configuration) {
		self.configuration = configuration
		let name = Constants.Keys.realmRepository.rawValue
		self.scheduler = RunLoopThreadScheduler(threadName: name)
	}
	public func getPlayable(ofMusic musics: [Music]) -> Observable<[Playable]> {
		let repository = Repository<Playable>(configuration: configuration)
		let predicate = NSPredicate(format: "uid IN %@", musics.compactMap{$0.playableID})
		return repository.query(with: predicate)
	}
	
	public func getPlayable(ofURL url: URL) -> Observable<[Playable]> {
		let repository = Repository<Playable>(configuration: configuration)
		let predicate = NSPredicate(format: "path == %@", url.absoluteString)
		return repository.query(with: predicate)
	}
	
	public func getMusics(ofAlbum album: Album) -> Observable<[Music]> {
		let repository = Repository<Music>(configuration: configuration)
		let predicate = NSPredicate(format: "albumID = %@", album.uid)
		return repository.query(with: predicate)
	}
	
	public func getMusics(ofPlaylist playlist: Playlist) -> Observable<[Music]> {
		return Observable.create { observer in
			let realm = self.realm
			let predicate = NSPredicate(format: "playlistID = %@", playlist.uid)
			let objects = realm.objects(RMPlaylistTrack.self).filter(predicate).compactMap({ [unowned self](track) -> Music? in
				let realm = self.realm
				let object = realm.object(ofType: RMMusic.self, forPrimaryKey: track.musicID)?.asDomain()
				return object
			})
			observer.onNext(Array(objects))
			observer.onCompleted()
			return Disposables.create()
		}
	}
	
	public func getMusics(ofArtist artist: Artist) -> Observable<[Music]> {
		let repository = Repository<Music>(configuration: configuration)
		let predicate = NSPredicate(format: "artistID = %@", artist.uid)
		return repository.query(with: predicate)
	}
	public func getMusicsCount(ofArtist artist: Artist) -> Int {
		let repository = Repository<Music>(configuration: configuration)
		let predicate = NSPredicate(format: "artistID = %@", artist.uid)
		return repository.countAll(with: predicate)
	}

	public func getAlbum(ofMusic music: Music) -> Observable<Album?> {
		let repository = Repository<Album>(configuration: configuration)
		return repository.object(forPrimaryKey: music.albumID)
	}
	
	public func getArtist(ofMusic music: Music) -> Observable<Artist?> {
		let repository = Repository<Artist>(configuration: configuration)
		return repository.object(forPrimaryKey: music.artistID)
	}
	
	public func getArtist(ofAlbum album: Album) -> Observable<Artist?> {
		let repository = Repository<Artist>(configuration: configuration)
		return repository.object(forPrimaryKey: album.artistID)
	}
	
	public func getPlaylists(ofCollection collection: FeaturedCollections) -> Observable<[Playlist]> {
		return Observable.create { observer in
			let realm = self.realm
			let predicate = NSPredicate(format: "collectionID = %@", collection.uid)
			let objects = realm.objects(RMCollectionList.self).filter(predicate).compactMap({ [unowned self](collectionList) -> Playlist? in
				let realm = self.realm
				let object = realm.object(ofType: RMPlaylist.self, forPrimaryKey: collectionList.playlistID)?.asDomain()
				return object
			})
			observer.onNext(Array(objects))
			observer.onCompleted()
			return Disposables.create()
		}
	}
	public func getMusics(ofPlayable playable: Playable) -> Observable<[Music]>{
		let repository = Repository<Music>(configuration: configuration)
		let predicate = NSPredicate(format: "playableID = %@", playable.uid)
		return repository.query(with: predicate).take(1)
	}
	public func getAlbums(ofArtist artist: Artist) -> Observable<[Album]> {
		let repository = Repository<Album>(configuration: configuration)
		let predicate = NSPredicate(format: "artistID = %@", artist.uid)
		return repository.query(with: predicate)
	}
	
	public func getPlaylists(Contains music: Music) -> Observable<[Playlist]> {
		return Observable.create { observer in
			let realm = self.realm
			let predicate = NSPredicate(format: "musicID = %@", music.uid)
			let objects = Array(realm.objects(RMPlaylistTrack.self).filter(predicate).compactMap({ (tracks) -> Playlist? in
				let realm = self.realm
				let object = realm.object(ofType: RMPlaylist.self, forPrimaryKey: tracks.playlistID)?.asDomain()
				return object
			}))
			observer.onNext(objects)
			observer.onCompleted()
			return Disposables.create()
		}
	}
	
	public func artworks( items: [ArtworkContainedProtocol]) -> Observable<[Artwork]>{
		let predicate = NSPredicate(format: "uid IN %@", items.compactMap{$0.artworkID})
		let repository = Repository<Artwork>(configuration: configuration)
		return repository.query(with: predicate)
	}

}
