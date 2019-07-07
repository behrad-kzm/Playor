//
//  Album.swift
//  Domain
//
//  Created by Behrad Kazemi on 6/22/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import Foundation

public struct Album: ArtworkContainedProtocol, ArtistContainedProtocol, Codable {
	public let uid: String
	public let artworkID: String
	public let artistID: String
	public let title: String
	public let creationDate: Date
	public let liked: Bool
	public init(uid: String, artistID: String, title: String, creationDate: Date, artworkID: String, liked: Bool){
		self.uid = uid
		self.creationDate = creationDate
		self.artworkID = artworkID
		self.artistID = artistID
		self.liked = liked
		self.title = title
	}
}
extension Album: Equatable{
	public static func == (lhs: Album, rhs: Album) -> Bool {
		return lhs.uid == rhs.uid
	}
}
