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
	dynamic var uid = 0
	dynamic var playableID = 0
	dynamic var artistID = 0
	dynamic var artworkID = 0
	dynamic var title = ""
	dynamic var genre = ""
	dynamic var creationDate = Date()
	dynamic var playCount = 0
	dynamic var rate = 0.0
}
