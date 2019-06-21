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
	dynamic var uid = 0
	dynamic var artworkID = 0
	dynamic var title = ""
	dynamic var creationDate = Date()
	dynamic var liked = false

}
extension RMPlaylist: DomainConvertibleType {
	func asDomain() -> Playlist {
		return Playlist(uid: uid, title: title, creationDate: creationDate, artworkID: artworkID, liked: liked)
	}
}

extension Playlist: RealmRepresentable {
	func asRealm() -> RMPlaylist {
		return RMPlaylist.build { object in
			object.uid = uid
			object.artworkID = artworkID
			object.title = title
			object.creationDate = creationDate
			object.liked = liked
		}
	}
}
