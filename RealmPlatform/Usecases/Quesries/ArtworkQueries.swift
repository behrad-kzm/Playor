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
