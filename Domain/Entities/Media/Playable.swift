//
//  Playable.swift
//  Domain
//
//  Created by Behrad Kazemi on 6/14/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
public struct Playable: Codable {
	public let uid: String
	public let format: String
	public let url: URL
	public let source: DataSourceType = .local
	public init(uid: String, url: URL, format: String){
		self.uid = uid
		self.format = format
		self.url = url
	}
}
extension Playable: Equatable{
	public static func == (lhs: Playable, rhs: Playable) -> Bool {
		return lhs.uid == rhs.uid && lhs.url == rhs.url
	}
}
