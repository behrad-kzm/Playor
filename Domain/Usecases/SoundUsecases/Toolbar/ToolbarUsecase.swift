//
//  ToolbarUsecase.swift
//  Domain
//
//  Created by Behrad Kazemi on 6/20/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import RxSwift

public protocol ToolbarUsecase {

	func setup(models: [Playable], index: Int)
	func next()
	func previous()
	func getStatus() -> BehaviorSubject<PlayerStatus>
	func getCurrent() -> BehaviorSubject<Playable?>
	func pause()
	func resume()
	func seekForward(duration: TimeInterval)
	func seekBakward(duration: TimeInterval)
	
}
