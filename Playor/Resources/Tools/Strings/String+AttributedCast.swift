//
//  String+AttributedCast.swift
//  Crypton
//
//  Created by Behrad Kazemi on 5/16/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import UIKit
extension String {
	func toAttributedString(color: UIColor, font: UIFont) -> NSMutableAttributedString{
		let attribute = [ NSAttributedString.Key.font: font ,NSAttributedString.Key.foregroundColor: color]
		let preString = NSMutableAttributedString(string: self, attributes: attribute)
		return preString
	}
}
