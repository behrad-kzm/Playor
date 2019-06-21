//
//  Artist.swift
//  Domain
//
//  Created by Behrad Kazemi on 6/21/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
public struct Artist {
	public let uid: Int
	public let artworkID: Int
	public let albumIDs: [Int]
	public init(uid: Int, data: Data, albumIDs){
		self.uid = uid
		self.data = data
	}
}
extension Artwork: Equatable{
	public static func == (lhs: Artwork, rhs: Artwork) -> Bool {
		return lhs.uid == rhs.uid
	}
}


+ artistID: Int
+ artworkID: Int
+ playlistIDs: [PlaylistID]
+ name: String
