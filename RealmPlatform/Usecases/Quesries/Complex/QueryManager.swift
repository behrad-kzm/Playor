//
//  QueryManager.swift
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

public final class QueryManager: Domain.QueryManager {
	
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
		self.setupArtworksIfNeeded()
	}
	public func getIOManager() -> Domain.IOManager {
		return IOManager(configuration: configuration)
	}
	
	func setupArtworksIfNeeded(){
		if !UserDefaults.standard.bool(forKey: setupArtworks){
			for index in 1...20 {
				if let imagePath = Bundle.main.path(forResource: String(index), ofType: "jpg"), let url = URL(string: imagePath){
					let uid = ArtworkPlaceholderType.banner.rawValue + "\(index)"
					let artwork = Artwork(uid: uid, dataURL: url)
					do {
						realm.add(artwork.asRealm())
					}
				}
			}
			UserDefaults.standard.set(true, forKey: setupArtworks)
		}
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
			let objects = Array(realm.objects(RMPlaylistTrack.self).filter(predicate).compactMap({ [unowned self](tracks) -> Playlist? in
				let realm = self.realm
				let object = realm.object(ofType: RMPlaylist.self, forPrimaryKey: tracks.playlistID)?.asDomain()
				return object
			}))
			return Observable.just(objects)
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
		return albumsInDatabase.map { [unowned self](albums) -> [Album] in
			return albums.compactMap({ (album) -> Album? in
				let realm = self.realm
				let albumPredicate = NSPredicate(format: "albumID = %@", album.uid)
				let objects = realm.objects(RMMusic.self).filter(albumPredicate)
				let avrage = objects.average(ofProperty: "rate") ?? 0.0
				if startRate...endRate ~= avrage {
					return album
				}
				return nil
			})
		}
	}
	
	public func getArtists(withRate rate: Double, radius: Double, fromDate: Date ) -> Observable<[Artist]> {
		let repository = Repository<Artist>(configuration: configuration)
		let startRate = rate - radius
		let endRate = rate + radius
		let artistsInDatabase = repository.queryAll()
		return artistsInDatabase.map { [unowned self](artists) -> [Artist] in
			return artists.compactMap({ (artist) -> Artist? in
				let realm = self.realm
				let artistPredicate = NSPredicate(format: "artistID = %@ AND creationDate >= %@", artist.uid, fromDate as CVarArg)
				let objects = realm.objects(RMMusic.self).filter(artistPredicate)
				let avrage = objects.average(ofProperty: "rate") ?? 0.0
				if startRate...endRate ~= avrage {
					return artist
				}
				return nil
			})
		}
	}
	public func getPlaylistQueries() -> Domain.PlaylistQueries {
		return PlaylistQueries(repository: Repository<Playlist>(configuration: configuration))
	}
	
	public func getAlbumsQueries() -> Domain.AlbumQueries {
		return AlbumQueries(repository: Repository<Album>(configuration: configuration))
	}
	
	public func getArtistQueries() -> Domain.ArtistQueries {
		return ArtistQueries(repository: Repository<Artist>(configuration: configuration))
	}
	public func getAtworksQueries() -> Domain.ArtworkQueries {
		return ArtworkQueries(repository: Repository<Artwork>(configuration: configuration))
	}
	
	public func getMusicQueries() -> Domain.MusicQueries {
		return MusicQueries(repository: Repository<Music>(configuration: configuration))
	}
	
	public func pickWeightedProbabilityMusic(fromDate: Date, toDate: Date, uidNot: [String], ByArtist artist: Artist) -> String{
		let predicate = NSPredicate(format: "(creationDate >= %@) AND (creationDate <= %@) AND (NOT (uid IN %@)) AND artistID == %@", fromDate as CVarArg, toDate as CVarArg, uidNot, artist.uid)
		return pickWightedMusic(predicate: predicate)
	}
	public func pickWeightedProbabilityMusic(fromDate: Date, toDate: Date, uidNot: [String]) -> String {
		let predicate = NSPredicate(format: "(creationDate >= %@) AND (creationDate <= %@) AND (NOT (uid IN %@))", fromDate as CVarArg, toDate as CVarArg, uidNot)
		return pickWightedMusic(predicate: predicate)
	}
	
	private func pickWightedMusic(predicate: NSPredicate) -> String {

			let realm = self.realm
			let objects = realm.objects(RMMusic.self).filter(predicate)
			let sumOfRates: Double = objects.sum(ofProperty: "rate")
			let probabilitiesTuple = objects.compactMap({ (item) -> (String, Float) in
				let weight = item.rate / sumOfRates
				return (item.uid, Float(weight))
			})
			let probabilities = probabilitiesTuple.map{$0.1}
			let sum = probabilities.reduce(0, +)
			var randomIndex = 0
			let rnd = Float.random(in: 0.0 ..< sum)
			var accum: Float = 0.0
			for (i, p) in probabilities.enumerated() {
				accum += p
				if rnd < accum {
					randomIndex = i
					break
				}
			}
			randomIndex = randomIndex >= probabilities.count ? (probabilities.count - 1) : randomIndex
			let randomID = probabilitiesTuple[randomIndex].0
			return randomID
	}
	public func topArtitst(maxCount: Int) -> Observable<[Artist]> {
		return Observable.deferred { [unowned self] in
			let realm = self.realm
			let objects = realm.objects(RMArtist.self).compactMap { (artist) -> (RMArtist,Double) in
				let artistPredicate = NSPredicate(format: "artistID = %@", artist.uid)
				let musicsResult = realm.objects(RMMusic.self).filter(artistPredicate)
				let avrage = musicsResult.average(ofProperty: "rate") ?? 0.0
				return (artist, avrage)
			}
			let maxSize = objects.count > maxCount ? maxCount : objects.count
			let sorted = objects.sorted(by: {$0.1 < $1.1})
			let result = sorted[0..<maxSize].map {$0.0.asDomain()}
			return Observable.just(result)
			}
			.subscribeOn(scheduler)
	}
}
