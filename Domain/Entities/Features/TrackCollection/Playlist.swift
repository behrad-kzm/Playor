//
//  Playlist.swift
//  Domain
//
//  Created by Behrad Kazemi on 6/21/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation

public struct Playlist: ArtworkContainedProtocol, Codable {
	public let uid: String
	public let artworkID: String
	public let title: String
	public let creationDate: Date
	public let liked: Bool
	public let rate: Double
	public let playCount: Int
	public let source: DataSourceType
	public init(uid: String, rate: Double, title: String, creationDate: Date, artworkID: String, liked: Bool, playCount: Int, source: DataSourceType = .generated){
		self.source = source
		self.uid = uid
		self.creationDate = creationDate
		self.artworkID = artworkID
		self.liked = liked
		self.title = title
		self.rate = rate
		self.playCount = playCount
	}
}
extension Playlist: Equatable{
	public static func == (lhs: Playlist, rhs: Playlist) -> Bool {
		return lhs.uid == rhs.uid
	}
}
