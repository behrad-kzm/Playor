//
//  MusicQuesries.swift
//  Domain
//
//  Created by Behrad Kazemi on 6/22/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import RxSwift

public protocol MusicQueries {
	
	func add(model: Music) -> Observable<Void>
	func delete(model: Music) -> Observable<Void>
	func getAll() -> Observable<[Music]>
	func setFavorite(liked: Bool, model: Music) -> Observable<Void>
	func addScore(model: Music, score: Double) -> Observable<Void>
	func increasePlayCount(model: Music) -> Observable<Void>
	func update(model: Music) -> Observable<Void>
	func get(uid: Int) -> Observable<Music?>
	func search(with predicate: NSPredicate, sortDescriptors: [NSSortDescriptor]) -> Observable<[Music]>
}
