//
//  Array+Tuple.swift
//  Domain
//
//  Created by Behrad Kazemi on 6/24/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
extension Array {
	func splat() -> () {
		return ()
	}
	
	func splat() -> (Element) {
		return (self[0])
	}
	
	func splat() -> (Element,Element) {
		return (self[0],self[1])
	}
	
	func splat() -> (Element,Element,Element) {
		return (self[0],self[1],self[2])
	}
	
	func splat() -> (Element,Element,Element,Element) {
		return (self[0],self[1],self[2],self[3])
	}
	
	func splat() -> (Element,Element,Element,Element,Element) {
		return (self[0],self[1],self[2],self[3],self[4])
	}
}
