//
//  PlayerInfoUseCase.swift
//  SoundsPlatform
//
//  Created by Behrad Kazemi on 6/22/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import RxSwift
import Domain

public final class PlayerInfoUseCase: Domain.PlayerInfoUsecase {
	
	let manager: SoundPlayer
	init(manager: SoundPlayer) {
		self.manager = manager
	}
	
	public func get() -> Observable<PlayerInfo> {
		return Observable<Int>.timer(1, scheduler: MainScheduler.instance).map { [unowned self](_) -> PlayerInfo in
			PlayerInfo(currentModel: self.manager.current, currentTime: self.manager.currentTime, isShuffle: self.manager.shuffled, repeatMode: self.manager.repeatType, status: self.manager.status)
		}
	}
}
