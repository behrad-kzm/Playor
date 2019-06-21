//
//  SoundUsecasProvider.swift
//  Domain
//
//  Created by Behrad Kazemi on 6/20/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
public protocol SoundUsecaseProvider {
	func makeToolbarUsecase() -> ToolbarUsecase
	func makeFullPlayerUsecase() -> FullPlayerUsecase
	func makeRemoteUsecase() -> RemoteUsecase
}
