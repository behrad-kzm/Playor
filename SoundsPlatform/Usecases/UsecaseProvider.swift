//
//  UsecaseProvider.swift
//  SoundsPlatform
//
//  Created by Behrad Kazemi on 6/20/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import Domain

public final class UseCaseProvider: Domain.SoundUsecaseProvider {

	private let soundManager: SoundPlayer
	private let queryManager: Domain.QueryManager
	public init(manager: Domain.QueryManager) {
		self.soundManager = SoundPlayer.shared
		self.queryManager = manager
	}
	
	public func makeToolbarUsecase() -> Domain.ToolbarUsecase {
		return ToolbarUsecase(manager: soundManager)
	}
	
	public func makeFullPlayerUsecase() -> Domain.FullPlayerUsecase {
		return FullPlayerUsecase(manager: soundManager)
	}
	
	public func makeRemoteUsecase() -> Domain.RemoteUsecase {
		return RemoteUsecase(manager: soundManager)
	}
	
	public func makeAudioFileHandler() -> Domain.AudioFileHandler {
		return AudioFileHandler(manager: queryManager)
	}
}
