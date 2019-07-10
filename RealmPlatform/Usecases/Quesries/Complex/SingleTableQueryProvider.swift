//
//  SingleTableQueryProvider.swift
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

public final class SingleTableQueryProvider: Domain.SingleTableQueryProvider {
	
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
}
