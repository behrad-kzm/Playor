//
//  PlaylistQueries.swift
//  Domain
//
//  Created by Behrad Kazemi on 6/22/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import RxSwift

public protocol PlaylistQueries {
	
	func add(model: Playlist) -> Observable<Void>
	func delete(model: Playlist) -> Observable<Void>
	func setFavorite(liked: Bool, model: Playlist) -> Observable<Void>
	func addScore(model: Playlist, score: Double) -> Observable<Void>
	func increasePlayCount(model: Playlist) -> Observable<Void>
	func update(model: Playlist) -> Observable<Void>
	func getAll() -> Observable<[Playlist]>
	func get(uid: Int) -> Observable<Playlist?>
	func search(with predicate: NSPredicate, sortDescriptors: [NSSortDescriptor]) -> Observable<[Playlist]>
}
