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
	public let uid: Int
	public let artworkID: Int
	public let artistID: Int
	public let title: String
	public let creationDate: Date
	public let liked: Bool
	public init(uid: Int, artistID: Int, title: String, creationDate: Date, artworkID: Int, liked: Bool){
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
