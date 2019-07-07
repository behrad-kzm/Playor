//
//  SuggestionUsecaseProvider.swift
//  SuggestionPlatform
//
//  Created by Behrad Kazemi on 6/25/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import RxSwift
import Domain
//[TODO] refactor below
public final class SuggestionUsecaseProvider: Domain.SuggestionUsecase {
	
	private let queryManager: Domain.QueryManager
	private let lastTwoWeeks: Date
	private let lastMonth: Date
	private let lastThreeMonth: Date
	private let lastSixMonth: Date
	private let lastYear: Date
	private let yearsAgo: Date
	private let timeDistributionWeights: [Date: Float]
	
	public init(queryManager: Domain.QueryManager) {
		self.queryManager = queryManager
		self.lastTwoWeeks = Calendar.current.date(byAdding: .day, value: -14, to: Date()) ?? Date()
		self.lastMonth =  Calendar.current.date(byAdding: .month, value: -1, to: lastTwoWeeks) ?? Date()
		self.lastThreeMonth = Calendar.current.date(byAdding: .month, value: -3, to: lastMonth) ?? Date()
		self.lastSixMonth = Calendar.current.date(byAdding: .month, value: -6, to: lastThreeMonth) ?? Date()
		self.lastYear = Calendar.current.date(byAdding: .year, value: -1, to: lastSixMonth) ?? Date()
		self.yearsAgo = Calendar.current.date(byAdding: .year, value: -10, to: lastYear) ?? Date()
		
		//weights created by data mining before
		self.timeDistributionWeights = [
			lastTwoWeeks: 0.41,
			lastMonth: 0.24,
			lastThreeMonth: 0.14,
			lastSixMonth: 0.09,
			lastYear: 0.07,
			yearsAgo: 0.05
		]
	}
	
	
	
	
	
	public func suggestCollection() -> Observable<FeaturedCollections> {
		let playlist1 = suggestWellRandomizedPlaylist()
		let playlist2 = queryManager.getArtistQueries().getAll().map{$0.randomElement()}.filter{$0 != nil}.flatMapLatest { [unowned self](artist) -> Observable<Playlist> in
			return self.suggestWellRandomizedPlaylist(byArtist: artist!)
		}
		
		let playlist3 = suggestWellRandomizedPlaylist()
		let playlist4 = queryManager.getArtistQueries().getAll().map{$0.randomElement()}.filter{$0 != nil}.flatMapLatest { [unowned self](artist) -> Observable<Playlist> in
			return self.suggestWellRandomizedPlaylist(byArtist: artist!)
		}
		let playlist5 = suggestWellRandomizedPlaylist()
		let playlists = Observable.combineLatest([playlist1,playlist2,playlist3,playlist4,playlist5])
		let title = CollectionNames().generateTitle()
		let artwork = queryManager.getAtworksQueries().getPlaceHolder(type: .banner, random: true)
		return Observable.combineLatest(artwork,playlists).flatMapLatest { (artwork, playlists) -> Observable<FeaturedCollections> in
			let collection = FeaturedCollections(uid: UUID().uuidString, title: title, creationDate: Date(), artworkID: artwork.uid)
			let obsCollection = Observable.just(collection)
			return self.queryManager.getIOManager().insert(FeaturedCollection: collection, Playlists: playlists).withLatestFrom(obsCollection)
		}
	}
	
	public func suggestWellRandomizedPlaylist() -> Observable<Playlist> {
		let dates = Array(timeDistributionWeights.keys)
		var musicIDS = [String]()
		for _ in 0...19 {
			let randomDateIndex = RandomSelection.randomNumber(probabilities: Array(timeDistributionWeights.values))
			let selectedDateRange = randomDateIndex > 0 ? (dates[randomDateIndex], dates[randomDateIndex - 1]) : (lastTwoWeeks, Date())
			musicIDS.append(queryManager.pickWeightedProbabilityMusic(fromDate: selectedDateRange.0, toDate: selectedDateRange.1, uidNot: musicIDS))
		}
		let title = PlaylistNames(artist: nil).generateTitle()
		return queryManager.getAtworksQueries().getPlaceHolder(type: .banner, random: true).flatMapLatest { [unowned self](artwork) -> Observable<Playlist> in
			let playlist = Playlist(uid: UUID().uuidString, rate: 1, title: title, creationDate: Date(), artworkID: artwork.uid, liked: false, playCount: 0, source: .generated)
			let obsPlaylist = Observable.just(playlist)
			return self.queryManager.getIOManager().insert(Playlist: playlist, TrackIDS: musicIDS, Artwork: artwork).withLatestFrom(obsPlaylist)
		
		}
	}
	
	public func suggestWellRandomizedPlaylist(byArtist artist: Artist) -> Observable<Playlist> {
		let dates = Array(timeDistributionWeights.keys)
		var musicIDS = [String]()
		
		for _ in 0...19 {
			let randomDateIndex = RandomSelection.randomNumber(probabilities: Array(timeDistributionWeights.values))
			let selectedDateRange = randomDateIndex > 0 ? (dates[randomDateIndex], dates[randomDateIndex - 1]) : (lastTwoWeeks, Date())
			musicIDS.append(queryManager.pickWeightedProbabilityMusic(fromDate: selectedDateRange.0, toDate: selectedDateRange.1, uidNot: musicIDS, ByArtist: artist))
		}
		let title = PlaylistNames(artist: artist).generateTitle()
		return queryManager.getAtworksQueries().getPlaceHolder(type: .banner, random: true).flatMapLatest { [unowned self](artwork) -> Observable<Playlist> in
			let playlist = Playlist(uid: UUID().uuidString, rate: 1, title: title, creationDate: Date(), artworkID: artwork.uid, liked: false, playCount: 0, source: .generated)
			let obsPlaylist = Observable.just(playlist)
			return self.queryManager.getIOManager().insert(Playlist: playlist, TrackIDS: musicIDS, Artwork: artwork).withLatestFrom(obsPlaylist)
		}
	}
	
	public func suggestTopArtists() -> Observable<[Artist]> {
		
		return queryManager.topArtitst(maxCount: 5)
	}
	
	public func suggestRecentMusics() -> Observable<[Music]> {
		let sort = NSSortDescriptor(key: "creationDate", ascending: true)
		let predicate = NSPredicate(format: "creationDate >= %@", lastMonth as CVarArg)
		return queryManager.getMusicQueries().search(with: predicate, sortDescriptors: [sort])
	}
	
	public func getAlbums() -> Observable<[Album]> {
		return queryManager.getAlbumsQueries().getAll()
	}
	
	public func getAlbums(byArtist artist: Artist) -> Observable<[Album]> {
		return queryManager.getAlbums(ofArtist: artist)
	}
}



