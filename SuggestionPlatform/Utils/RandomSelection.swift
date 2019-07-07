//
//  RandomSelection.swift
//  Domain
//
//  Created by Behrad Kazemi on 6/26/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
 enum RandomSelection {
	static func randomNumber(probabilities: [Float]) -> Int {
		
		// Sum of all probabilities (so that we don't have to require that the sum is 1.0):
		let sum = probabilities.reduce(0, +)
		// Random number in the range 0.0 <= rnd < sum :
		let rnd = Float.random(in: 0.0 ..< sum)
		// Find the first interval of accumulated probabilities into which `rnd` falls:
		var accum: Float = 0.0
		for (i, p) in probabilities.enumerated() {
			accum += p
			if rnd < accum {
				return i
			}
		}
		// This point might be reached due to floating point inaccuracies:
		return (probabilities.count - 1)
	}
}
