//
//  ComplexQueries.swift
//  RealmPlatform
//
//  Created by Behrad Kazemi on 6/25/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import RxSwift
import RxRealm
import Domain

public final class ComplexQueries: Domain.ComplexQueries {

	private let configuration: Realm.Configuration
	private let scheduler: RunLoopThreadScheduler

	private var realm: Realm {
		return try! Realm(configuration: self.configuration)
	}
	
	init(configuration: Realm.Configuration) {
		self.configuration = configuration
		let name = Constants.Keys.realmRepository.rawValue
		self.scheduler = RunLoopThreadScheduler(threadName: name)
	}
	
	
	public func getPlayable(ofMusic music: Music) -> Observable<Playable?> {
		return Observable.deferred {
			let realm = self.realm
			let object = realm.object(ofType: RMPlayable.self, forPrimaryKey: music.playableID)?.asDomain()
			return Observable.just(object)
			}
			.subscribeOn(scheduler)
	}
	
	public func getMusics(ofAlbum album: Album) -> Observable<[Music]> {
		let repository = Repository<Music>(configuration: configuration)
		let predicate = NSPredicate(format: "albumID = %@", album.uid)
		return repository.query(with: predicate)
	}
	
	public func getMusics(ofPlaylist playlist: Playlist) -> Observable<[Music]> {
		return Observable.deferred { [unowned self] in
			let realm = self.realm
			let predicate = NSPredicate(format: "playlistID = %@", playlist.uid)
			let objects = realm.objects(RMPlaylistTrack.self).filter(predicate).compactMap({ [unowned self](track) -> Music? in
				let realm = self.realm
				let object = realm.object(ofType: RMMusic.self, forPrimaryKey: track.musicID)?.asDomain()
				return object
			})
			return Observable.just(Array(objects))
			}
			.subscribeOn(scheduler)
	}
	
	public func getMusics(ofArtist artist: Artist) -> Observable<[Music]> {
		let repository = Repository<Music>(configuration: configuration)
		let predicate = NSPredicate(format: "artistID = %@", artist.uid)
		return repository.query(with: predicate)
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
		return Observable.deferred { [unowned self] in
			let realm = self.realm
			let predicate = NSPredicate(format: "collectionID = %@", collection.uid)
			let objects = realm.objects(RMCollectionList.self).filter(predicate).compactMap({ [unowned self](collectionList) -> Playlist? in
				let realm = self.realm
				let object = realm.object(ofType: RMPlaylist.self, forPrimaryKey: collectionList.playlistID)?.asDomain()
				return object
			})
			return Observable.just(Array(objects))
			}
			.subscribeOn(scheduler)
	}
	
	public func getAlbums(ofArtist artist: Artist) -> Observable<[Album]> {
		let repository = Repository<Album>(configuration: configuration)
		let predicate = NSPredicate(format: "artistID = %@", artist.uid)
		return repository.query(with: predicate)
	}
	
	public func getPlaylists(Contains music: Music) -> Observable<[Playlist]> {
		return Observable.deferred { [unowned self] in
			let realm = self.realm
			let predicate = NSPredicate(format: "musicID = %@", music.uid)
			let objects = realm.objects(RMPlaylistTrack.self).filter(predicate).compactMap({ [unowned self](tracks) -> Playlist? in
				let realm = self.realm
				let object = realm.object(ofType: RMPlaylist.self, forPrimaryKey: tracks.playlistID)?.asDomain()
				return object
			})
			return Observable.just(Array(objects))
			}
			.subscribeOn(scheduler)
	}
	
	public func getMusics(withRate rate: Double, radius: Double, fromDate: Date ) -> Observable<[Music]> {
		let repository = Repository<Music>(configuration: configuration)
		let startRate = rate - radius
		let endRate = rate + radius
		let predicate = NSPredicate(format: "rate BETWEEN {%@, %@} AND creationDate >= %@", startRate, endRate, fromDate as CVarArg)
		return repository.query(with: predicate)
	}
	
	public func getAlbums(withRate rate: Double, radius: Double, fromDate: Date ) -> Observable<[Album]> {
		let repository = Repository<Album>(configuration: configuration)
		let startRate = rate - radius
		let endRate = rate + radius
		let predicate = NSPredicate(format: "creationDate >= %@", fromDate as CVarArg)
		let albumsInDatabase = repository.query(with: predicate)
		let result = albumsInDatabase.map { [unowned self](albums) -> [Album] in
			return albums.compactMap({ (album) -> Album? in
				let realm = self.realm
				let albumPredicate = NSPredicate(format: "albumID = %@", album.uid)
				let objects = realm.objects(RMMusic.self).filter(albumPredicate)
				let avrage = objects.count > 0 ? (objects.reduce(0.0, { (previous, itrModel) -> Double in
					return previous + itrModel.rate
				}) / Double(objects.count) ) : 0
				if startRate...endRate ~= avrage {
					return album
				}
				return nil
			})
		}
		return result
	}
	
	public func getArtists(withRate rate: Double, radius: Double, fromDate: Date ) -> Observable<[Artist]> {
		let repository = Repository<Artist>(configuration: configuration)
		let startRate = rate - radius
		let endRate = rate + radius
		let artistsInDatabase = repository.queryAll()
		let result = artistsInDatabase.map { [unowned self](artists) -> [Artist] in
			return artists.compactMap({ (artist) -> Artist? in
				let realm = self.realm
				let artistPredicate = NSPredicate(format: "artistID = %@ AND creationDate >= %@", artist.uid, fromDate as CVarArg)
				let objects = realm.objects(RMMusic.self).filter(artistPredicate)
				let avrage = objects.count > 0 ? (objects.reduce(0.0, { (previous, itrModel) -> Double in
					return previous + itrModel.rate
				}) / Double(objects.count) ) : 0
				if startRate...endRate ~= avrage {
					return artist
				}
				return nil
			})
		}
		return result

	}

}
