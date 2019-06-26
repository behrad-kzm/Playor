//
//  Music.swift
//  Domain
//
//  Created by Behrad Kazemi on 6/21/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
public struct Music: ArtworkContainedProtocol, ArtistContainedProtocol, Codable {
	public let uid: Int
	public let artworkID: Int
	public let artistID: Int
	public let albumID: Int
	public let playableID: Int
	public let title: String
	public let albumName: String
	public let genre: String
	public let creationDate: Date
	public let playCount: Int
	public let rate: Double
	public let liked: Bool
	public let artistName: String
	public init(uid: Int,
							title: String,
							genre: String,
							artworkID: Int,
							artistID: Int,
							artistName: String,
							playableID: Int,
							creationDate: Date,
							playCount: Int,
							albumID: Int,
							albumName: String,
							rate: Double,
							liked: Bool) {
		
		self.uid = uid
		self.title = title
		self.genre = genre
		self.artworkID = artworkID
		self.albumID = albumID
		self.artistID = artistID
		self.playableID = playableID
		self.artistName = artistName
		self.creationDate = creationDate
		self.playCount = playCount
		self.rate = rate
		self.liked = liked
		self.albumName = albumName
	}
}

extension Music: Equatable {
	public static func == (lhs: Music, rhs: Music) -> Bool {
		return lhs.playableID == rhs.playableID || lhs.uid == rhs.uid
	}
}
