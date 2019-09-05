//
//  RMPlayable.swift
//  RealmPlatform
//
//  Created by Behrad Kazemi on 6/21/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Domain
import RealmSwift
import Realm

final class RMPlayable: Object {
	@objc dynamic var uid = UUID().uuidString
	@objc dynamic var format = ""
	@objc dynamic var path = ""
	@objc dynamic var source = DataSourceType.local.rawValue
	override static func primaryKey() -> String {
		return "uid"
	}
}
extension RMPlayable: DomainConvertibleType {
	func asDomain() -> Playable {
		if source == DataSourceType.iTunes.rawValue{
			let playableURL = URL(string: path)!
			return Playable(uid: uid, url: playableURL, format: format)
		}
		let pathArr = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
		let route =  pathArr.first! + "/" + path
		let playableURL = URL(string: route) ?? Bundle.main.url(forResource: "Splash", withExtension: "mp3")!
		return Playable(uid: uid, url: playableURL, format: format)
	}
}
extension Playable: RealmRepresentable {
	func asRealm() -> RMPlayable {
		return RMPlayable.build { object in
			object.uid = uid
			object.format = format
			object.source = source.rawValue
			if source == .iTunes {
				object.path = url.absoluteString
			} else {
				object.path = url.lastPathComponent
			}
		}
	}
}
