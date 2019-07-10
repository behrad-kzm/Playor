//
//  WeightedQueries.swift
//  Domain
//
//  Created by Behrad Kazemi on 7/10/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import RxSwift
public protocol WeightedQueries {
	
	func pickWeightedProbabilityMusic(fromDate: Date, toDate: Date, uidNot: [String]) -> String
	func pickWeightedProbabilityMusic(fromDate: Date, toDate: Date, uidNot: [String], ByArtist: Artist) -> String
	
	func getMusics(withRate rate: Double, radius: Double, fromDate: Date) -> Observable<[Music]>
	func getAlbums(withRate rate: Double, radius: Double, fromDate: Date) -> Observable<[Album]>
	func getArtists(withRate rate: Double, radius: Double, fromDate: Date) -> Observable<[Artist]>
	func topArtitst(maxCount: Int) -> Observable<[Artist]>
}
