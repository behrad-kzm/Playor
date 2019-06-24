//
//  FeaturedCollectionQueries.swift
//  RealmPlatform
//
//  Created by Behrad Kazemi on 6/23/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import RxSwift
import Domain

public final class FeaturedCollectionQueries: Domain.FeaturedCollectionQueries {
	
	private let repository: Repository<FeaturedCollections>
	init(repository: Repository<FeaturedCollections>) {
		self.repository = repository
	}
	
	public func add(model: FeaturedCollections) -> Observable<Void> {
		return repository.save(entity: model)
	}
	
	public func delete(model: FeaturedCollections) -> Observable<Void> {
		return repository.delete(entity: model)
	}
	
	public func getAll() -> Observable<[FeaturedCollections]> {
		return repository.queryAll()
	}
	
	public func search(with predicate: NSPredicate, sortDescriptors: [NSSortDescriptor]) -> Observable<[FeaturedCollections]> {
		return repository.query(with: predicate, sortDescriptors: sortDescriptors)
	}
}
