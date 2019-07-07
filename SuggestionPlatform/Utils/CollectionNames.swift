//
//  CollectionNames.swift
//  SuggestionPlatform
//
//  Created by Behrad Kazemi on 7/5/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import Domain
struct CollectionNames {
	
	private let commonPrefixes = [
		"Hot Collections",
		"Well Mixed",
		"You will like them",
		"By Playor",
		"Surprise!"]
	
	func generateTitle() -> String {
		return commonPrefixes.randomElement() ?? "Auto Generated"
	}
	
}
