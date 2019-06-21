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
	dynamic var uid = 0
	dynamic var data = Data()

}
extension RMArtwork: DomainConvertibleType {
	func asDomain() -> Artwork {
		return Artwork(uid: uid, data: data)
	}
}

extension Artwork: RealmRepresentable {
	func asRealm() -> RMArtwork {
		return RMArtwork.build { object in
			object.uid = uid
			object.data = data
		}
	}
}
