//
//  ArtworkQueries.swift
//  RealmPlatform
//
//  Created by Behrad Kazemi on 6/23/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import RxSwift
import Domain

public final class ArtworkQueries: Domain.ArtworkQueries {
	public func getPlaceHolder(type: ArtworkPlaceholderType, random: Bool) -> Observable<Artwork> {
		let predicate = NSPredicate(format: "uid BEGINSWITH[c] %@", type.rawValue)
		let objects = repository.query(with: predicate)
		return objects.map({ (artworks) -> Artwork? in
			if random {
				return artworks.randomElement()
			}
			return artworks.first
		}).filter{$0 != nil}.map{$0!}
	}
	
	private let repository: Repository<Artwork>
	init(repository: Repository<Artwork>) {
		self.repository = repository
	}
	
	public func add(model: Artwork) -> Observable<Void> {
		return repository.save(entity: model)
	}
	
	public func delete(model: Artwork) -> Observable<Void> {
		return repository.delete(entity: model)
	}
	
	public func update(model: Artwork) -> Observable<Void> {
		return repository.save(entity: model)
	}
	
	public func get(model: ArtworkContainedProtocol) -> Observable<Artwork?> {
		return repository.object(forPrimaryKey: model.artworkID)
	}
}
