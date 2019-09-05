//
//  ToolbarUsecase.swift
//  SoundsPlatform
//
//  Created by Behrad Kazemi on 6/20/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import RxSwift
import Domain

public final class ToolbarUsecase: Domain.ToolbarUsecase {
	
	let manager: SoundPlayer

	init(manager: SoundPlayer) {
		self.manager = manager
	}
	
	public func setup(models: [Playable], index: Int) {
		manager.setup(list: models, index: index)
	}
	
	public func next() {
		manager.next()
	}
	
	public func previous() {
		manager.previous()
	}
	
	public func getCurrent() -> BehaviorSubject<Playable?> {
		return manager.currentObs
	}
	public func getStatus() -> BehaviorSubject<PlayerStatus> {		
		return manager.statusObs
	}
	public func pause() {
		manager.pause()
	}
	
	public func resume() {
		manager.resume()
	}
	
	public func seekForward(duration: TimeInterval) {
		let desired = manager.currentTime + duration
		manager.seekTo(desiredTime: desired)
	}
	
	public func seekBakward(duration: TimeInterval) {
		let desired = manager.currentTime - duration
		manager.seekTo(desiredTime: desired)
	}
	
	
}
