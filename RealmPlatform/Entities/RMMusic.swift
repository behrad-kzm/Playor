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
	@objc dynamic var uid = UUID().uuidString
	@objc dynamic var playableID = UUID().uuidString
	@objc dynamic var artistID = UUID().uuidString
	@objc dynamic var albumID = UUID().uuidString
	@objc dynamic var artworkID = UUID().uuidString
	@objc dynamic var title = ""
	@objc dynamic var genre = ""
	@objc dynamic var albumName = ""
	@objc dynamic var artistName = ""
	@objc dynamic var creationDate = Date()
	@objc dynamic var playCount = 0
	@objc dynamic var liked = false
	@objc dynamic var rate = 0.1
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
