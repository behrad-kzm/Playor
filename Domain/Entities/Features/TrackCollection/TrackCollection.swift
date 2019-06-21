//
//  TrackCollection.swift
//  Domain
//
//  Created by Behrad Kazemi on 6/21/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation

public struct TrackCollection: Codable {
		public let title: String
		public let tracks: String
		
		public init(AccessToken token: String, refreshToken: String) {
			self.token = token
			self.refreshToken = refreshToken
		}
}
