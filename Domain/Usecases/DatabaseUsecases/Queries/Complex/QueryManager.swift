//
//  QueryManager.swift
//  Domain
//
//  Created by Behrad Kazemi on 6/25/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import RxSwift
public protocol QueryManager {

	//eachone is a handler (Single responsibility)
	func getIOManager() -> IOManager
	func getWeightedQueries() -> WeightedQueries
	func getSingleTableQueries() -> SingleTableQueryProvider
	func getSearchingQueries() -> SearchingQueries
	
}
