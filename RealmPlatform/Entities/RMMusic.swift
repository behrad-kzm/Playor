//
//  RMMusic.swift
//  RealmPlatform
//
//  Created by Behrad Kazemi on 6/21/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Domain
import RealmSwift
import Realm

final class RMMusic: Object {
	dynamic var uid = UUID().uuidString
	dynamic var playableID = UUID().uuidString
	dynamic var artistID = UUID().uuidString
	dynamic var albumID = UUID().uuidString
	dynamic var artworkID = UUID().uuidString
	dynamic var title = ""
	dynamic var genre = ""
	dynamic var albumName = ""
	dynamic var artistName = ""
	dynamic var creationDate = Date()
	dynamic var playCount = 0
	dynamic var liked = false
	dynamic var rate = 0.0
	override static func primaryKey() -> String {
		return "uid"
	}
}
extension RMMusic: DomainConvertibleType {
	func asDomain() -> Music {
		return Music(uid: uid, title: title, genre: genre, artworkID: artworkID, artistID: artistID, artistName: artistName, playableID: playableID, creationDate: creationDate, playCount: playCount, albumID: albumID, albumName: albumName, rate: rate, liked: liked)
	}
}

extension Music: RealmRepresentable {
	func asRealm() -> RMMusic {
		return RMMusic.build { object in
			object.uid = uid
			object.artworkID = artworkID
			object.artistID = artistID
			object.playCount = playCount
			object.playableID = playableID
			object.albumID = albumID
			object.albumName = albumName
			object.artistName = artistName
			object.title = title
			object.genre = genre
			object.rate = rate
			object.liked = liked
			object.creationDate = creationDate
		}
	}
}
