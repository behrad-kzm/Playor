//
//  Music.swift
//  Domain
//
//  Created by Behrad Kazemi on 6/21/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
public struct Music: ArtworkContainedProtocol, ArtistContainedProtocol, Codable {
	public let uid: String
	public let artworkID: String
	public let artistID: String
	public let albumID: String
	public let playableID: String
	public let title: String
	public let albumName: String
	public let genre: String
	public let creationDate: Date
	public let playCount: Int
	public let rate: Double
	public let duration: Double
	public let liked: Bool
	public let artistName: String
	public init(uid: String,
							title: String,
							genre: String,
							artworkID: String,
							artistID: String,
							artistName: String,
							playableID: String,
							creationDate: Date,
							playCount: Int,
							albumID: String,
							albumName: String,
							rate: Double,
							liked: Bool,
							duration: Double) {
		
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
		self.duration = duration
	}
}

extension Music: Equatable {
	public static func == (lhs: Music, rhs: Music) -> Bool {
		return lhs.playableID == rhs.playableID || lhs.uid == rhs.uid
	}
}
