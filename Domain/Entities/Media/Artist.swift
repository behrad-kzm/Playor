//
//  Artist.swift
//  Domain
//
//  Created by Behrad Kazemi on 6/21/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
public struct Artist: ArtworkContainedProtocol, Codable {
	public let uid: String
	public let artworkID: String
	public let name: String
	public let liked: Bool
	
	public init(uid: String, name: String, artworkID: String, liked: Bool){
		self.uid = uid
		self.name = name
		self.artworkID = artworkID
		self.liked = liked
	}
}
extension Artist: Equatable{
	public static func == (lhs: Artist, rhs: Artist) -> Bool {
		return lhs.name == rhs.name && lhs.uid == rhs.uid
	}
}
