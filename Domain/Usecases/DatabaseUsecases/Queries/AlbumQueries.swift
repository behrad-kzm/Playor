//
//  AlbumQueries.swift
//  Domain
//
//  Created by Behrad Kazemi on 6/22/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import RxSwift

public protocol AlbumQueries {
	
	func add(model: Album) -> Observable<Void>
	func delete(model: Album) -> Observable<Void>
	func setFavorite(liked: Bool, model: Album) -> Observable<Void>
	func update(model: Album) -> Observable<Void>
	func getAll() -> Observable<[Album]>
	func search(with predicate: NSPredicate, sortDescriptors: [NSSortDescriptor]) -> Observable<[Album]>
	func albums(withName name: String, artistID: String) -> Observable<[Album]>
}
