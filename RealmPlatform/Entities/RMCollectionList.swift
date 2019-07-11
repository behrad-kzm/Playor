//
//  RMCollectionList.swift
//  RealmPlatform
//
//  Created by Behrad Kazemi on 6/21/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Domain
import RealmSwift
import Realm

final class RMCollectionList: Object {
	@objc dynamic var uid = UUID().uuidString
	@objc dynamic var collectionID = UUID().uuidString
	@objc dynamic var playlistID = UUID().uuidString
	override static func primaryKey() -> String {
		return "uid"
	}
}
