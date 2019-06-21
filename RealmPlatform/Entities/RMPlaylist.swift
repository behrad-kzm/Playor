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
	dynamic var name = ""
	dynamic var creationDate = Date()
	dynamic var rate = 0.0
}
