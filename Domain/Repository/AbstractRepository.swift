//
//  AbstractRepository.swift
//  Domain
//
//  Created by Behrad Kazemi on 6/22/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import RxSwift
public protocol AbstractRepository {
	associatedtype T
	func queryAll() -> Observable<[T]>
	func query(with predicate: NSPredicate,
						 sortDescriptors: [NSSortDescriptor]) -> Observable<[T]>
	func save(entity: T) -> Observable<Void>
	func delete(entity: T) -> Observable<Void>
	func countAll() -> Int
	func countAll(with predicate: NSPredicate) -> Int
	func object(forPrimaryKey key: String) -> Observable<T?>
	func delete(forPrimaryKey key: String) -> Observable<Void>
}
