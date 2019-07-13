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
				if let imagePath = Bundle.main.path(forResource: String(index), ofType: "jpg"){
					let uid = ArtworkPlaceholderType.banner.rawValue + "\(index)"
					let artwork = Artwork(uid: uid, dataURL: imagePath)
					do {
						realm.add(artwork.asRealm())
					}
				}
			}
			UserDefaults.standard.set(true, forKey: setupArtworks)
		}
	}
	
	public func getWeightedQueries() -> Domain.WeightedQueries {
		return WeightedQueries(configuration: configuration)
	}
	
	public func getSingleTableQueries() -> Domain.SingleTableQueryProvider {
		return SingleTableQueryProvider(configuration: configuration)
	}
	
	public func getSearchingQueries() -> Domain.SearchingQueries {
		return SearchingQueries(configuration: configuration)
	}
}
