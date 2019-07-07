//
//  PlaylistQueries.swift
//  RealmPlatform
//
//  Created by Behrad Kazemi on 6/23/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import RxSwift
import Domain

public final class PlaylistQueries: Domain.PlaylistQueries {
	
	private let repository: Repository<Playlist>
	init(repository: Repository<Playlist>) {
		self.repository = repository
	}
	
	public func add(model: Playlist) -> Observable<Void> {
		return repository.save(entity: model)
	}
	
	public func delete(model: Playlist) -> Observable<Void> {
		return repository.delete(entity: model)
	}
	
	public func setFavorite(liked: Bool, model: Playlist) -> Observable<Void> {
		
		//		[TODO] make update for genericRepository
		let newModel = Playlist(uid: model.uid, rate: model.rate, title: model.title, creationDate: model.creationDate, artworkID: model.artworkID, liked: liked, playCount: model.playCount, source: model.source)
		return repository.save(entity: newModel)
	}
	
	public func addScore(model: Playlist, score: Double) -> Observable<Void> {
		let rate = model.rate + score
		let newModel = Playlist(uid: model.uid, rate: rate, title: model.title, creationDate: model.creationDate, artworkID: model.artworkID, liked: model.liked, playCount: model.playCount, source: model.source)
		return repository.save(entity: newModel)
	}
	
	public func increasePlayCount(model: Playlist) -> Observable<Void> {
		let count = model.playCount + 1
		let newModel = Playlist(uid: model.uid, rate: model.rate, title: model.title, creationDate: model.creationDate, artworkID: model.artworkID, liked: model.liked, playCount: count, source: model.source)
		return repository.save(entity: newModel)
	}
	
	public func update(model: Playlist) -> Observable<Void> {
		return repository.save(entity: model)
	}
	
	public func getAll() -> Observable<[Playlist]> {
		return repository.queryAll()
	}
	
	public func get(uid: String) -> Observable<Playlist?> {
		return repository.object(forPrimaryKey: uid)
	}
	
	public func search(with predicate: NSPredicate, sortDescriptors: [NSSortDescriptor]) -> Observable<[Playlist]> {
		return repository.query(with: predicate, sortDescriptors: sortDescriptors)
	}
}
