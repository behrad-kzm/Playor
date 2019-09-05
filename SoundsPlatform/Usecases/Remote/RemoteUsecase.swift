//
//  RemoteUsecase.swift
//  SoundsPlatform
//
//  Created by Behrad Kazemi on 6/20/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import RxSwift
import Domain

public final class RemoteUsecase: Domain.RemoteUsecase {
	
	let manager: SoundPlayer
	init(manager: SoundPlayer) {
		self.manager = manager
	}
	
	public func setup(models: [Playable], index: Int) {
		manager.setup(list: models, index: index)
	}
	
	public func getCurrent() -> BehaviorSubject<Playable?> {
		return manager.currentObs
	}
	
	public func getStatus() -> BehaviorSubject<PlayerStatus>{
		return manager.statusObs
	}
	
	public func pause() {
		manager.pause()
	}
	
	public func resume() {
		manager.resume()
	}
	
	public func sufflePlay(models: [Playable]) {
		manager.setup(list: models.shuffled(), index: 0)
		manager.shuffled = true
	}
}
