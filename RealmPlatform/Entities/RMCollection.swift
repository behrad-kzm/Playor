//
//  RMCollection.swift
//  RealmPlatform
//
//  Created by Behrad Kazemi on 6/21/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Domain
import RealmSwift
import Realm

final class RMCollection: Object {
	@objc dynamic var uid = UUID().uuidString
	@objc dynamic var artworkID = UUID().uuidString
	@objc dynamic var title = ""
	@objc dynamic var creationDate = Date()
	dynamic var source: DataSourceType = .generated
	override static func primaryKey() -> String {
		return "uid"
	}
}
extension RMCollection: DomainConvertibleType {
	func asDomain() -> FeaturedCollections {
		return FeaturedCollections(uid: uid, title: title, creationDate: creationDate, artworkID: artworkID, source:  source)
	}
}

extension FeaturedCollections: RealmRepresentable {
	func asRealm() -> RMCollection {
		return RMPlaylist.build { object in
			object.uid = uid
			object.artworkID = artworkID
			object.title = title
			object.source = source
			object.creationDate = creationDate
		}
	}
}
