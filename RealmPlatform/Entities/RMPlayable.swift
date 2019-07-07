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
	dynamic var uid = UUID().uuidString
	dynamic var format = ""
	dynamic var path = ""
	dynamic var source: DataSourceType = .local
	override static func primaryKey() -> String {
		return "uid"
	}
}
extension RMPlayable: DomainConvertibleType {
	func asDomain() -> Playable {
		let pathArr = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
		let route =  pathArr.first! + "/" + path
		let cleanPath = path.removingPercentEncoding ?? route
		let webSafeURL = "file:///private" + cleanPath.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
		let playableURL = URL(string: webSafeURL) ?? Bundle.main.url(forResource: "Splash", withExtension: "mp3")!
		return Playable(uid: uid, url: playableURL, format: format)
	}
}
extension Playable: RealmRepresentable {
	func asRealm() -> RMPlayable {
		return RMPlayable.build { object in
			object.uid = uid
			object.format = format
			object.path = url.absoluteString
			object.source = source
		}
	}
}
