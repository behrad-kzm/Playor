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
	public let name: String
	public let liked: Bool
	
	public init(uid: Int, name: String, artworkID: Int, liked: Bool){
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
