//
//  FullPlayerUsecase.swift
//  Domain
//
//  Created by Behrad Kazemi on 6/20/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import RxSwift
import MediaPlayer
public protocol FullPlayerUsecase {
	
	func setup(models: [Playable], index: Int)
	func next()
	func previous()
	func getUpNext() ->Observable<[Playable]>
	func pause()
	func resume()
	func seekForward(duration: TimeInterval)
	func seekBakward(duration: TimeInterval)
	func seekTo(destination: TimeInterval)
	func getPlayerInformation() -> Observable<PlayerInfo>
	func setSuffle(isSheffled: Bool)
	func setRepeat(mode: MPRepeatType)
}
