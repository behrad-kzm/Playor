//
//  Playlist.swift
//  Domain
//
//  Created by Behrad Kazemi on 6/21/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation

public struct Playlist {
	public let uid: Int
	public let artworkID: Int
	public let title: String
	public let creationDate: Date
	public let liked: Bool
	public init(uid: Int, title: String, creationDate: Date, artworkID: Int, liked: Bool){
		self.uid = uid
		self.creationDate = creationDate
		self.artworkID = artworkID
		self.liked = liked
		self.title = title
	}
}
extension Playlist: Equatable{
	public static func == (lhs: Playlist, rhs: Playlist) -> Bool {
		return lhs.uid == rhs.uid
	}
}
