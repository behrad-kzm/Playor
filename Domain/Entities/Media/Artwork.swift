//
//  Artwork.swift
//  Domain
//
//  Created by Behrad Kazemi on 6/21/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
public struct Artwork: Codable {
	public let uid: Int
	public let data: Data
	public init(uid: Int, data: Data){
		self.uid = uid
		self.data = data
	}
}
extension Artwork: Equatable{
	public static func == (lhs: Artwork, rhs: Artwork) -> Bool {
		return lhs.uid == rhs.uid
	}
}
