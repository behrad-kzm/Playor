//
//  ACHeaderVM.swift
//  Playor
//
//  Created by Behrad Kazemi on 9/6/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Domain
final class ACHeaderVM: ViewModelType {
	
	private let playerUsecase: FullPlayerUsecase
	private let dataUsecase: AudioControllerUseCase
	private let initialArtworkPath: String
	private let initialTitle: String
	private let initialStatus: PlayerStatus
	private let initialSliderTime: TimeInterval
	init(playerUsecase: FullPlayerUsecase, dataUsecase: AudioControllerUseCase, artowrkPath: String, title: String, playingStatus: PlayerStatus, currentTime: TimeInterval) {
		self.playerUsecase = playerUsecase
		self.dataUsecase = dataUsecase
		self.initialArtworkPath = artowrkPath
		self.initialTitle = title
		self.initialStatus = playingStatus
		self.initialSliderTime = currentTime
	}
	
	func transform(input: Input) -> Output {
		let errorTracker = ErrorTracker()
		let fetchingTracker = ActivityIndicator()
		let currentInfo = playerUsecase.getPlayerInformation().share(replay: 1, scope: .forever)
		let current = currentInfo.map { (info) -> Playable? in
			return info.currentModel
			}.filter{$0 != nil}.map{$0!}
		let currentMusic = current.distinctUntilChanged({ (previous, latest) -> Bool in
			previous.url == latest.url
		}).flatMapLatest ({ [dataUsecase](playable) -> Observable<Music> in
			return dataUsecase.toMusic(item: playable)
		}).share(replay: 1, scope: .forever)
		
		let artowrkACPath = currentMusic.flatMapLatest({ [dataUsecase](music) -> Observable<Artwork> in
			return dataUsecase.toArtwork(items: [music]).filter{$0.count > 0}.map{$0.first!}
		}).map({ (artwork) -> String in
			return artwork.dataPath
		}).share(replay: 1, scope: .forever).asDriverOnErrorJustComplete()
		
		let currentSongTitle = Driver.merge(currentMusic.map { (music) -> String in
			music.title + " - " + music.artistName
			}.asDriverOnErrorJustComplete(), Driver.just(initialTitle))
		let status = currentInfo.map { (info) -> PlayerStatus in
			return info.status
			}.asDriverOnErrorJustComplete()
		let playpause = input.playPause.withLatestFrom(status)
		let pauseAction = playpause.filter{$0 == .playing}.do(onNext: { [playerUsecase](_) in
			playerUsecase.pause()
		})
		let resumeAction = playpause.filter{$0 != .playing}.do(onNext: { [playerUsecase](_) in
			playerUsecase.resume()
		})
		let playPauseAction = Driver.merge(Driver.just(initialStatus),resumeAction, pauseAction).asSharedSequence()
		let playNext = input.next.do(onNext: { [playerUsecase]() in
			playerUsecase.next()
		}).asDriver()
		let playPrevious = input.previous.do(onNext: { [playerUsecase]() in
			playerUsecase.previous()
		}).asDriver()
		
		let forward = input.forward.do(onNext: { [playerUsecase]() in
			playerUsecase.seekForward(duration: 1)
		}).asDriver()
		
		let backward = input.backward.do(onNext: { [playerUsecase]() in
			playerUsecase.seekBakward(duration: 1)
		}).asDriver()
		let currentTime = currentInfo.map { (info) -> Double in
			info.currentTime
		}.asDriverOnErrorJustComplete()
		let duration = currentMusic.map { (music) -> Double in
			music.duration
		}
		let currentTimePercent = Observable.combineLatest(duration, currentInfo).map { (musicDuration, info) -> Float in
			if musicDuration > 0 {
				return Float(info.currentTime / musicDuration)
			}
			return 0.0
		}.asDriverOnErrorJustComplete()
		let seek = Driver.zip(duration.asDriverOnErrorJustComplete(), input.currentSlider.skip(1)).do(onNext: { [playerUsecase] (duration, seeked) in
			let desiredTime = duration * Double(seeked)
			playerUsecase.seekTo(destination: desiredTime)
		}).mapToVoid()
		return Output(artworkACPath: Driver.merge(artowrkACPath, Driver.just(initialArtworkPath)), songTitleAC: currentSongTitle, playPause: playPauseAction, next: playNext, currentTimePercent: currentTimePercent, currentTime: currentTime, duration: duration.asDriverOnErrorJustComplete(), seekAction: seek, forward: forward, previous: playPrevious, backward: backward, isFetching: fetchingTracker.asDriver(), error: errorTracker.asDriver())
	}
}
extension ACHeaderVM {
	struct Input {
		
		let currentSlider: Driver<Float>
		let playPause: Driver<Void>
		let next: Driver<Void>
		let previous: Driver<Void>
		let forward: Driver<Void>
		let backward: Driver<Void>
	}
	
	struct Output {
		let artworkACPath: Driver<String>
		let songTitleAC: Driver<String>
		let playPause: Driver<PlayerStatus>
		let next: Driver<Void>
		let currentTimePercent: Driver<Float>
		let currentTime: Driver<Double>
		let duration: Driver<Double>
		let seekAction: Driver<Void>
		let forward: Driver<Void>
		let previous: Driver<Void>
		let backward: Driver<Void>
		let isFetching: Driver<Bool>
		let error: Driver<Error>
	}
}
