//
//  WeightedQueries.swift
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

public final class WeightedQueries: Domain.WeightedQueries {
	
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
		if sum == 0 {
			return ""
		}
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
		return Observable.deferred { 
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
