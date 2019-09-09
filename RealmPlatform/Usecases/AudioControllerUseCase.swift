//
//  AudioControllerUseCase.swift
//  RealmPlatform
//
//  Created by Behrad Kazemi on 9/6/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import RxSwift
import Domain
import MediaPlayer
public final class AudioControllerUseCase: Domain.AudioControllerUseCase {

	private let getMusicsOfPlayable: (_ playable: Playable) -> Observable<[Music]>
	private let getArtworks: (_ artworks: [ArtworkContainedProtocol]) -> Observable<[Artwork]>
	public init(artworkQuery: @escaping  (_ artworks: [ArtworkContainedProtocol]) -> Observable<[Artwork]>, musicFromPlayable: @escaping (_ playable: Playable) -> Observable<[Music]>){
		self.getMusicsOfPlayable = musicFromPlayable
		self.getArtworks = artworkQuery
	}

	
	public func track(music: Music) -> Observable<Void> {
		return Observable.just(())
	}
	
	public func toMusic(item: Playable) -> Observable<Music> {
		let result = getMusicsOfPlayable(item).filter{$0.count > 0}.map{$0.first!}
		return result
	}
	
	public func toArtwork(items: [ArtworkContainedProtocol]) -> Observable<[Artwork]> {
		let result = getArtworks(items)
		return result.map { (artworks) -> [Artwork] in
			return items.compactMap({ (item) -> Artwork? in
				return artworks.filter{$0.uid == item.artworkID}.first
			})
		}
	}
}
