//
//  RMAlbum.swift
//  RealmPlatform
//
//  Created by Behrad Kazemi on 6/21/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Domain
import RealmSwift
import Realm

final class RMAlbum: Object {
	@objc dynamic var uid = UUID().uuidString
	@objc dynamic var artistID = UUID().uuidString
	@objc dynamic var artworkID = UUID().uuidString
	@objc dynamic var title = ""
	@objc dynamic var creationDate = Date()
	@objc dynamic var liked = false
	override static func primaryKey() -> String {
		return "uid"
	}
}
extension RMAlbum: DomainConvertibleType {
	func asDomain() -> Album {
		return Album(uid: uid, artistID: artistID, title: title, creationDate: creationDate, artworkID: artworkID, liked: liked)
	}
}

extension Album: RealmRepresentable {
	func asRealm() -> RMAlbum {
		return RMPlaylist.build { object in
			object.uid = uid
			object.artworkID = artworkID
			object.title = title
			object.liked = liked
			object.artistID = artistID
			object.creationDate = creationDate
		}
	}
}
