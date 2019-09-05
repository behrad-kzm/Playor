//
//  ArtistQueries.swift
//  RealmPlatform
//
//  Created by Behrad Kazemi on 6/23/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import RxSwift
import Domain

public final class ArtistQueries: Domain.ArtistQueries {

	
	private let repository: Repository<Artist>
	init(repository: Repository<Artist>) {
		self.repository = repository
	}

	public func add(model: Artist) -> Observable<Void> {
		return repository.save(entity: model)
	}
	
	public func delete(model: Artist) -> Observable<Void> {
		return repository.delete(entity: model)
	}
	
	public func getAll() -> Observable<[Artist]> {
		return repository.queryAll()
	}
	
	
	public func update(model: Artist) -> Observable<Void> {
		return repository.save(entity: model)
	}
	
	public func get(model: ArtistContainedProtocol) -> Observable<Artist?> {
		return repository.object(forPrimaryKey: model.artistID)
	}
	
	public func search(with predicate: NSPredicate, sortDescriptors: [NSSortDescriptor]) -> Observable<[Artist]> {
		return repository.query(with: predicate, sortDescriptors: sortDescriptors)
	}
	public 	func artists(with name: String) -> Observable<[Artist]> {
		print("searching for artist \(name)")
		let predicate = NSPredicate(format: "name == %@", name)
		return repository.query(with: predicate).share(replay: 1, scope: .forever).takeLast(1).do(onNext: { (artists) in
			print("fuck u bro\(artists)")
		})
		
	}
}
