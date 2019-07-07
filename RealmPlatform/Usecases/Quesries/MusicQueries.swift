//
//  MusicQueries.swift
//  RealmPlatform
//
//  Created by Behrad Kazemi on 6/23/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import RxSwift
import Domain

public final class MusicQueries: Domain.MusicQueries {	
	
	private let repository: Repository<Music>
	init(repository: Repository<Music>) {
		self.repository = repository
	}

	public func add(model: Music) -> Observable<Void> {
		return repository.save(entity: model)
	}
	
	public func delete(model: Music) -> Observable<Void> {
		return repository.save(entity: model)
	}
	
	public func getAll() -> Observable<[Music]> {
		return repository.queryAll()
	}
	
	public func setFavorite(liked: Bool, model: Music) -> Observable<Void> {
		//		[TODO] make update for genericRepository
		let newModel = Music(uid: model.uid, title: model.title, genre: model.genre, artworkID: model.artworkID, artistID: model.artistID, artistName: model.artistName, playableID: model.playableID, creationDate: model.creationDate, playCount: model.playCount, albumID: model.albumID, albumName: model.albumName, rate: model.rate, liked: liked)
		return repository.save(entity: newModel)
	}
	
	public func addScore(model: Music, score: Double) -> Observable<Void> {
		let rate = model.rate + score
		let newModel = Music(uid: model.uid, title: model.title, genre: model.genre, artworkID: model.artworkID, artistID: model.artistID, artistName: model.artistName, playableID: model.playableID, creationDate: model.creationDate, playCount: model.playCount, albumID: model.albumID, albumName: model.albumName, rate: rate, liked: model.liked)
		return repository.save(entity: newModel)
	}
	
	public func increasePlayCount(model: Music) -> Observable<Void> {
		let count = model.playCount + 1
		let newModel = Music(uid: model.uid, title: model.title, genre: model.genre, artworkID: model.artworkID, artistID: model.artistID, artistName: model.artistName, playableID: model.playableID, creationDate: model.creationDate, playCount: count, albumID: model.albumID, albumName: model.albumName, rate: model.rate, liked: model.liked)
		return repository.save(entity: newModel)
	}
	
	public func update(model: Music) -> Observable<Void> {
		return repository.save(entity: model)
	}
	
	public func get(uid: String) -> Observable<Music?> {
		return repository.object(forPrimaryKey: uid)
	}

	public func search(with predicate: NSPredicate, sortDescriptors: [NSSortDescriptor]) -> Observable<[Music]> {
		return repository.query(with: predicate, sortDescriptors: sortDescriptors)
	}
	
}
