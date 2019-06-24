//
//  FeaturedCollectionQueries.swift
//  Domain
//
//  Created by Behrad Kazemi on 6/22/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import RxSwift

public protocol FeaturedCollectionQueries {
	
	func add(model: FeaturedCollections) -> Observable<Void>
	func delete(model: FeaturedCollections) -> Observable<Void>
	func getAll() -> Observable<[FeaturedCollections]>
	func search(with predicate: NSPredicate, sortDescriptors: [NSSortDescriptor]) -> Observable<[FeaturedCollections]>
}
