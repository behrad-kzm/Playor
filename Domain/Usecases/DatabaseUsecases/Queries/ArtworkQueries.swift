//
//  ArtworkQueries.swift
//  Domain
//
//  Created by Behrad Kazemi on 6/22/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import RxSwift

public protocol ArtworkQueries {
	func add(model: Artwork) -> Observable<Void>
	func delete(model: Artwork) -> Observable<Void>
	func update(model: Artwork) -> Observable<Void>
	func getPlaceHolder(type: ArtworkPlaceholderType, random: Bool) -> Observable<Artwork>
	func get(model: ArtworkContainedProtocol) -> Observable<Artwork?>
	func search(with predicate: NSPredicate) -> Observable<[Artwork]>
}
