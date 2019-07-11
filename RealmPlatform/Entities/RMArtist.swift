//
//  RMArtist.swift
//  RealmPlatform
//
//  Created by Behrad Kazemi on 6/21/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Domain
import RealmSwift
import Realm

final class RMArtist: Object {
	@objc dynamic var uid = UUID().uuidString
	@objc dynamic var artworkID = UUID().uuidString
	@objc dynamic var name = ""
	@objc dynamic var liked = false
	
	override static func primaryKey() -> String {
		return "uid"
	}
}
extension RMArtist: DomainConvertibleType {
	func asDomain() -> Artist {
		return Artist(uid: uid, name: name, artworkID: artworkID, liked: liked)
	}
}

extension Artist: RealmRepresentable {
	func asRealm() -> RMArtist {
		return RMArtist.build { object in
			object.uid = uid
			object.artworkID = artworkID
			object.liked = liked
			object.name = name
		}
	}
}
