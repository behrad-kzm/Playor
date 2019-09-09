//
//  AudioControllerUseCase.swift
//  Domain
//
//  Created by Behrad Kazemi on 9/6/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import RxSwift

public protocol AudioControllerUseCase {
	func toArtwork(items: [ArtworkContainedProtocol]) -> Observable<[Artwork]>
	func toMusic(item: Playable) -> Observable<Music>
	func track(music: Music) -> Observable<Void>

}
