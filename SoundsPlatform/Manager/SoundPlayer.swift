//
//  SoundPlayer.swift
//  SoundsPlatform
//
//  Created by Behrad Kazemi on 6/14/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//
import UIKit
import AVFoundation
import MediaPlayer
import Domain
import RxSwift
public class SoundPlayer: NSObject, AVAudioPlayerDelegate {
	// MARK: - Properties
	private var audioPlayer = AVAudioPlayer()
	private let audioSession = AVAudioSession()
	var repeatType = MPRepeatType.off
	var shuffled: Bool! {
		didSet {
			if shuffled {
				playingAudios.shuffle()
				return
			}
			playingAudios = audios
		}
	}
	private(set) var current: Playable? {
		didSet {
			currentObs.onNext(current)
		}
	}
	
	private(set) var status: PlayerStatus! {
		didSet {
			statusObs.onNext(status)
		}
	}
	var currentTime: TimeInterval {
		return audioPlayer.currentTime
	}
	private(set) var currentObs: BehaviorSubject<Playable?>!
	private(set) var statusObs: BehaviorSubject<PlayerStatus>!
	private(set) var playingAudios: [Playable]!
	private(set) var audios: [Playable]! {
		didSet {
			playingAudios = audios
		}
	}
	//TODO [remove shared]
	public static let shared: SoundPlayer = {
		let manager = SoundPlayer()
		manager.statusObs = BehaviorSubject<PlayerStatus>(value: .stopped)
		manager.currentObs = BehaviorSubject<Playable?>(value: nil)
		manager.status = .stopped
		manager.current = nil
		manager.shuffled = false
		manager.audios = [Playable]()
		do {
			try manager.audioSession.setCategory(.playback)
			try manager.audioSession.setActive(true)
		}catch let error as NSError{
			//			Analytics.logError(fileName: "SoundPlayer", error: error , descriptions: "Failed to set the audio session category and mode: \(error.localizedDescription)")
		}
		RemoteControllersHandler.setupRemoteHandlers(ForManager: manager)
		return manager
	}()
	
	// MARK: - Functions
	func seekTo(desiredTime time: TimeInterval){
		
		if audioPlayer.duration >= time && time >= 0{
			audioPlayer.currentTime = time
		}
	}
	
	public func setup(list: [Playable], index: Int){
		audios = list
		let safeIndex = (index >= list.count) ? (list.count - 1) : index
		current = list[safeIndex]
		play(Model: current!)
	}
	private func play(Model audio: Playable){
			do {
				audioPlayer = try AVAudioPlayer(contentsOf: audio.url)
//				self.audioPlayer.delegate = self
				status = .playing
				current = audio
				audioPlayer.play()
//				self.updateControlCenter()
			}catch{
				next()
				print("Player Error!")
			}
	}
	
	func pause(){
		status = .paused
		audioPlayer.pause()
	}
	func resume(){
		status = .playing
		audioPlayer.play()
	}
	func stop(){}
	func next(){}
	func previous(){}
}
