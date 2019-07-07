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
	dynamic var uid = UUID().uuidString
	dynamic var artworkID = UUID().uuidString
	dynamic var title = ""
	dynamic var creationDate = Date()
	dynamic var liked = false
	dynamic var rate = 0.0
	dynamic var playCount = 0
	dynamic var source: DataSourceType = .generated
	override static func primaryKey() -> String {
		return "uid"
	}
}
extension RMPlaylist: DomainConvertibleType {
	func asDomain() -> Playlist {
		return Playlist(uid: uid, rate: rate, title: title, creationDate: creationDate, artworkID: artworkID, liked: liked, playCount: playCount, source: source)
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
			object.source = source
			object.creationDate = creationDate
			object.liked = liked
		}
	}
}
