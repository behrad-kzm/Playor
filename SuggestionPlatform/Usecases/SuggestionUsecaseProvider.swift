//
//  SuggestionUsecaseProvider.swift
//  SuggestionPlatform
//
//  Created by Behrad Kazemi on 6/25/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import RxSwift
import Domain

public final class SuggestionUsecaseProvider: Domain.SuggestionUsecase {
	private let queryManager: Domain.ComplexQueries
	public init(queryManager: Domain.ComplexQueries) {
		self.queryManager = queryManager
	}
	public func suggest(CollectionByOption option: QueryOptions) -> Observable<[FeaturedCollections]> {
		
	}
	
	public func suggest(PlaylistByOption option: QueryOptions) -> Observable<[Playlist]> {
		
	}
	
	public func suggest(PlaylistByOption option: QueryOptions, byArtist artist: Artist) -> Observable<[Playlist]> {
		
	}
	
	public func suggest(ArtistByOption option: QueryOptions) -> Observable<[Artist]> {
		
	}
	
	public func suggest(AlbumsByOption option: QueryOptions) -> Observable<[Album]> {
		
	}
	
	public func suggest(AlbumsByOption option: QueryOptions, byArtist artist: Artist) -> Observable<[Album]> {
		
	}
	
	public func suggest(MusicByOption option: QueryOptions) -> Observable<[Music]> {
		
	}
	
	


	
}
