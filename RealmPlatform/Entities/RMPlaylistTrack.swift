//
//  RMPlaylistTrack.swift
//  RealmPlatform
//
//  Created by Behrad Kazemi on 6/21/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Domain
import RealmSwift
import Realm

final class RMPlaylistTrack: Object {
	dynamic var uid = 0
	dynamic var musicID = 0
	dynamic var playlistID = 0
}
