//
//  RMPlaylist.swift
//  RealmPlatform
//
//  Created by Behrad Kazemi on 6/21/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Domain
import RealmSwift
import Realm

final class RMPlaylist: Object {
	@objc dynamic var uid = UUID().uuidString
	@objc dynamic var artworkID = UUID().uuidString
	@objc dynamic var title = ""
	@objc dynamic var creationDate = Date()
	@objc dynamic var liked = false
	@objc dynamic var rate = 0.0
	@objc dynamic var playCount = 0
	@objc dynamic var source = DataSourceType.generated.rawValue
	override static func primaryKey() -> String {
		return "uid"
	}
}
extension RMPlaylist: DomainConvertibleType {
	func asDomain() -> Playlist {
		return Playlist(uid: uid, rate: rate, title: title, creationDate: creationDate, artworkID: artworkID, liked: liked, playCount: playCount, source: DataSourceType(rawValue: source) ?? .generated)
	}
}

extension Playlist: RealmRepresentable {
	func asRealm() -> RMPlaylist {
		return RMPlaylist.build { object in
			object.uid = uid
			object.rate = rate
			object.artworkID = artworkID
			object.title = title
			object.playCount = playCount
			object.source = source.rawValue
			object.creationDate = creationDate
			object.liked = liked
		}
	}
}
