//
//  ArtistQueries.swift
//  Domain
//
//  Created by Behrad Kazemi on 6/22/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import RxSwift

public protocol ArtistQueries {
	
	func add(model: Artist) -> Observable<Void>
	func delete(model: Artist) -> Observable<Void>
	func getAll() -> Observable<[Artist]>
	func update(model: Artist) -> Observable<Void>
	func get(model: ArtistContainedProtocol) -> Observable<Artist?>
	func search(with predicate: NSPredicate, sortDescriptors: [NSSortDescriptor]) -> Observable<[Artist]>
	func artists(with name: String) -> Observable<[Artist]>
}
