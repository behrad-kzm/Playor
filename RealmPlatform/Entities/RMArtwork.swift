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
	dynamic var uid = UUID().uuidString
	dynamic var dataURL = ""
	dynamic var source: DataSourceType = .local
	override static func primaryKey() -> String {
		return "uid"
	}
}
extension RMArtwork: DomainConvertibleType {
	func asDomain() -> Artwork {
		return Artwork(uid: uid, dataURL: URL(string: dataURL)!, source: source)
	}
}

extension Artwork: RealmRepresentable {
	func asRealm() -> RMArtwork {
		return RMArtwork.build { object in
			object.uid = uid
			object.source = source
			object.dataURL = dataURL.absoluteString
		}
	}
}
