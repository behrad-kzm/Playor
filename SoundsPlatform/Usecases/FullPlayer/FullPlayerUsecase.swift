//
//  FullPlayerUsecase.swift
//  SoundsPlatform
//
//  Created by Behrad Kazemi on 6/20/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import RxSwift
import Domain
import MediaPlayer

public final class FullPlayerUsecase: Domain.FullPlayerUsecase {
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
	
	public func getUpNext() -> Observable<[Playable]> {
		return manager.currentObs.asObservable().map { (model) -> [Playable] in
			if let safeModel = model, let currentIndex = self.manager.playingAudios.firstIndex(of: safeModel) {
				 let splitedArray = Array(self.manager.playingAudios[currentIndex ..< self.manager.playingAudios.count])
				return splitedArray
			}
		return [Playable]()
		}
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
	
	public func seekTo(destination: TimeInterval) {
		manager.seekTo(desiredTime: destination)
	}
	
	public func getPlayerInformation() -> Observable<PlayerInfo> {
		return Observable<Int>.interval(1, scheduler: MainScheduler.instance).map { [unowned self](_) -> PlayerInfo in
			return PlayerInfo(currentModel: self.manager.current, currentTime: self.manager.currentTime, isShuffle: self.manager.shuffled, repeatMode: self.manager.repeatType, status: self.manager.status)
		}
	}
	
	public func setSuffle(isSheffled: Bool) {
		manager.shuffled = isSheffled
	}
	
	public func setRepeat(mode: MPRepeatType) {
		manager.repeatType = mode
	}
	
}
