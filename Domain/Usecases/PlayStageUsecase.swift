//
//  PlayStageUsecase.swift
//  Domain
//
//  Created by Behrad Kazemi on 6/22/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import RxSwift

public protocol PlayStageUsecase {
	func getDataModel() -> Observable<PlayStageDataModel.Response>
	func toPlayable(tracks: [Music]) -> Observable<[Playable]>
	func toArtwork(items: [ArtworkContainedProtocol]) -> Observable<[Artwork]>
	func track(music: Music) -> Observable<Void>
	func track(playlist: Playlist) -> Observable<Void>
	func track(album: Album) -> Observable<Void>
	func track(collection: FeaturedCollections) -> Observable<Void>
}
