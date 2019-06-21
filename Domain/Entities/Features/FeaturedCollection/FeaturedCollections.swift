//
//  FeaturedCollections.swift
//  Domain
//
//  Created by Behrad Kazemi on 6/22/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
public struct FeaturedCollections {
	public let uid: Int
	public let artworkID: Int
	public let title: String
	public let creationDate: Date

	public init(uid: Int, title: String, creationDate: Date, artworkID: Int){
		self.uid = uid
		self.creationDate = creationDate
		self.artworkID = artworkID
		self.title = title
	}
}
extension FeaturedCollections: Equatable{
	public static func == (lhs: FeaturedCollections, rhs: FeaturedCollections) -> Bool {
		return lhs.uid == rhs.uid
	}
}
