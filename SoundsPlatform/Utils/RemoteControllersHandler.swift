//
//  RemoteControllersHandler.swift
//  PlayCenter
//
//  Created by behard kazemi on 3/9/18.
//  Copyright © 2018 behard kazemi. All rights reserved.
//

import UIKit
import MediaPlayer
class RemoteControllersHandler{
	
	static func setupRemoteHandlers(ForManager soundPlayer: SoundPlayer){
		
		let center = MPRemoteCommandCenter.shared()
		
		[center.stopCommand,center.playCommand,center.pauseCommand, center.togglePlayPauseCommand, center.nextTrackCommand, center.previousTrackCommand, center.changeRepeatModeCommand, center.changeShuffleModeCommand, center.changePlaybackPositionCommand].forEach {
			$0.isEnabled = true
		}
		
		center.changePlaybackPositionCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
			guard let desiredTime = (event as? MPChangePlaybackPositionCommandEvent)?.positionTime else{
				//                    Analytics.printDebugText(text: "RemoteControllersHandler: seek failed")
				return .commandFailed
			}
			soundPlayer.seekTo(desiredTime: desiredTime)
			return .success
		}
		
		center.changeRepeatModeCommand.addTarget { [weak manager = soundPlayer](event) -> MPRemoteCommandHandlerStatus in
			let repeatType = (event as! MPChangeRepeatModeCommandEvent).repeatType
			manager?.repeatType = repeatType
			return .success
		}
		center.pauseCommand.addTarget { [weak manager = soundPlayer](event) -> MPRemoteCommandHandlerStatus in
			manager?.pause()
			return .success
		}
		center.stopCommand.addTarget { [weak manager = soundPlayer](event) -> MPRemoteCommandHandlerStatus in
			manager?.stop()
			return .success
		}
		center.changeShuffleModeCommand.addTarget { [weak manager = soundPlayer](event) -> MPRemoteCommandHandlerStatus in
			let shuffleType = (event as! MPChangeShuffleModeCommandEvent).shuffleType
			manager?.shuffled = shuffleType != .off
			return .success
		}
		center.nextTrackCommand.addTarget { [weak manager = soundPlayer](event) -> MPRemoteCommandHandlerStatus in
			manager?.next()
			return .success
		}
		center.previousTrackCommand.addTarget { [weak manager = soundPlayer](event) -> MPRemoteCommandHandlerStatus in
			manager?.previous()
			return .success
		}
		center.togglePlayPauseCommand.addTarget { [weak manager = soundPlayer](event) -> MPRemoteCommandHandlerStatus in
			if manager?.status != .playing{
				manager?.resume()
			}else{
				manager?.pause()
			}
			return .success
		}
		center.playCommand.addTarget { [weak manager = soundPlayer](event) -> MPRemoteCommandHandlerStatus in
			manager?.resume()
			return .success
		}
	}
//	 func handleRemoteControlEvents(eventType: UIEvent.EventSubtype){
//		switch eventType {
//		case .remoteControlBeginSeekingForward:
//			SoundPlayer.shared.seekForward()
//			break
//		case .remoteControlEndSeekingForward:
//			SoundPlayer.shared.stopSeeking()
//			break
//		case .remoteControlBeginSeekingBackward:
//			SoundPlayer.shared.seekBackward()
//			break
//		case .remoteControlEndSeekingBackward:
//			SoundPlayer.shared.stopSeeking()
//			break
//		default:
//			break
//		}
//	}
}
