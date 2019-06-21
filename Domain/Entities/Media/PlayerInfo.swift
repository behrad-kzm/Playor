//
//  PlayerInfo.swift
//  Domain
//
//  Created by Behrad Kazemi on 6/20/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import MediaPlayer
public struct PlayerInfo {
	public let currentModel: Playable?
	public let currentTime: TimeInterval
	public let isShuffle: Bool
	public let status: PlayerStatus
	public let repeatMode: MPRepeatType
	
	public init(currentModel: Playable?, currentTime: TimeInterval, isShuffle: Bool, repeatMode: MPRepeatType, status: PlayerStatus){
		self.currentModel = currentModel
		self.currentTime = currentTime
		self.isShuffle = isShuffle
		self.repeatMode = repeatMode
		self.status = status
	}
}
