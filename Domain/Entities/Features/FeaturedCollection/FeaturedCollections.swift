//
//  FeaturedCollections.swift
//  Domain
//
//  Created by Behrad Kazemi on 6/22/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
public struct FeaturedCollections: Codable {
	public let uid: Int
	public let artworkID: Int
	public let title: String
	public let creationDate: Date
	public let source: DataSourceType
	public init(uid: Int, title: String, creationDate: Date, artworkID: Int, source: DataSourceType = .generated){
		self.source = source
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
