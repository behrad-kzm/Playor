//
//  AlbumQueries.swift
//  RealmPlatform
//
//  Created by Behrad Kazemi on 6/23/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import RxSwift
import RxRealm
import Domain

public final class AlbumQueries: Domain.AlbumQueries {
	private let repository: Repository<Album>
	init(repository: Repository<Album>) {
		self.repository = repository
	}

	public func add(model: Album) -> Observable<Void> {
		return repository.save(entity: model)
	}
	
	public func delete(model: Album) -> Observable<Void> {
		return repository.delete(entity: model)
	}
	
	public func setFavorite(liked: Bool, model: Album) -> Observable<Void> {
//		[TODO] make update for genericRepository
		let newAlbum = Album(uid: model.uid, artistID: model.artistID, title: model.title, creationDate: model.creationDate, artworkID: model.artworkID, liked: liked)
		return repository.save(entity: newAlbum)
	}
	
	public func update(model: Album) -> Observable<Void> {
		return repository.save(entity: model)
	}
	
	public func getAll() -> Observable<[Album]> {
		return repository.queryAll()
	}
	
	public func search(with predicate: NSPredicate, sortDescriptors: [NSSortDescriptor]) -> Observable<[Album]> {
		return repository.query(with: predicate, sortDescriptors: sortDescriptors)
	}
	
}
