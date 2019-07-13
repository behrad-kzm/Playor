//
//  PlayStageDataModel.swift
//  Domain
//
//  Created by Behrad Kazemi on 6/23/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
public enum PlayStageDataModel: InteractiveModelType {
	public struct Request: Codable {
	}
	
	public struct Response: Codable {
		//[TODO] make this respose dynamic collectionModel
		public let albums: [Album]?
		public let forYou: [Music]?
		public let recent: [Music]?
		public let bestOfArtists: [Playlist]?
		public init(albums: [Album]?, forYou: [Music]?, recent: [Music]?, bestOfArtists: [Playlist]?) {
			self.albums = albums
			self.forYou = forYou
			self.recent = recent
			self.bestOfArtists = bestOfArtists
		}
	}
}
