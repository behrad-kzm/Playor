//
//  RemoteUsecase.swift
//  Domain
//
//  Created by Behrad Kazemi on 6/20/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import RxSwift
import MediaPlayer

public protocol RemoteUsecase {
	func setup(models: [Playable], index: Int)
	func sufflePlay(models: [Playable])
	func getCurrent() -> BehaviorSubject<Playable?>
	func getStatus() -> BehaviorSubject<PlayerStatus>
	func pause()
	func resume()
}
