//
//  String+CastToPersian.swift
//
//  Created by Behrad Kazemi on 4/13/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
extension String{
    func persianNumbersRepresentation() -> String{
        let numbersDictionary : Dictionary = ["0" : "۰","1" : "۱", "2" : "۲", "3" : "۳", "4" : "۴", "5" : "۵", "6" : "۶", "7" : "۷", "8" : "۸", "9" : "۹"]
        var str : String = self
        
        for (key,value) in numbersDictionary {
            str =  str.replacingOccurrences(of: key, with: value)
        }
        
        return str
    }
    func englishNumbersRepresentation() -> String{
        let numbersDictionary : Dictionary = ["۰" : "0", "۱" :"1", "۲" : "2", "۳" : "3", "۴" : "4", "۵" : "5", "۶" : "6" ,"۷" : "7", "۸" : "8", "۹" : "9"]
        var str : String = self
        
        for (key,value) in numbersDictionary {
            str =  str.replacingOccurrences(of: key, with: value)
        }
        
        return str
    }
}
