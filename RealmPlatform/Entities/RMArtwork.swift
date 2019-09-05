//
//  RMArtwork.swift
//  RealmPlatform
//
//  Created by Behrad Kazemi on 6/21/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Domain
import RealmSwift
import Realm

final class RMArtwork: Object {
	@objc dynamic var uid = UUID().uuidString
	@objc dynamic var dataURL = ""
	@objc dynamic var source = DataSourceType.local.rawValue
	override static func primaryKey() -> String {
		return "uid"
	}
}
extension RMArtwork: DomainConvertibleType {
	func asDomain() -> Artwork {
		let pathArr = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)

		let cleanPath = dataURL.removingPercentEncoding ?? ""

		if source == DataSourceType.bundle.rawValue {
			let route = Bundle.main.path(forResource: cleanPath.components(separatedBy: ".").first!, ofType: "jpg") ?? ""
			
			return Artwork(uid: uid, dataURL: route, source: DataSourceType(rawValue: source) ?? .local)
		}
				let route =  pathArr.first! + "/" + cleanPath
		return Artwork(uid: uid, dataURL: route, source: DataSourceType(rawValue: source) ?? .local)
	}
}

extension Artwork: RealmRepresentable {
	func asRealm() -> RMArtwork {
		return RMArtwork.build { object in
			object.uid = uid
			object.source = source.rawValue
			object.dataURL = URL(fileURLWithPath: dataPath).lastPathComponent
		}
	}
}
