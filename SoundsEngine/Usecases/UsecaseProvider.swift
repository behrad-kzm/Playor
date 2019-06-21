//
//  UsecaseProvider.swift
//  SoundsEngine
//
//  Created by Behrad Kazemi on 6/20/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import Domain

public final class UseCaseProvider: Domain.SoundUsecaseProvider {

	private let manager: SoundPlayer
	public init() {
		manager = SoundPlayer.shared
	}
	
	public func makeToolbarUsecase() -> Domain.ToolbarUsecase {
		return ToolbarUsecase(manager: manager)
	}
	
	public func makeFullPlayerUsecase() -> Domain.FullPlayerUsecase {
		return FullPlayerUsecase(manager: manager)
	}
	
	public func makeRemoteUsecase() -> Domain.RemoteUsecase {
		return RemoteUsecase(manager: manager)
	}
	
}
