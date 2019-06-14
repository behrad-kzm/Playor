//
//  String+Validation.swift
//  Crypton
//
//  Created by Behrad Kazemi on 5/16/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import UIKit
extension String {

	func isValidPhoneNumber() -> Bool {
		
		var phone = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
		
		if phone.isEmpty {
			return false
		}
		
		phone = self.englishNumbersRepresentation()
		
		let phoneRegex = "^09[0-9'@s]{9,9}$"
		let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
		let result =  phoneTest.evaluate(with: phone)
		return result
	}
	
	func isValidEmail()-> Bool {
		
		var emailAddress = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
		
		if emailAddress.isEmpty {
			return false
		}
		
		emailAddress = self.englishNumbersRepresentation()
		
		let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
		let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
		return emailTest.evaluate(with: emailAddress)
}
}
