//
//  Bundle+LoadView.swift
//  BarandehShow
//
//  Created by Behrad Kazemi on 4/14/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import UIKit
extension Bundle {
    
    static func loadView<T>(fromNib name: String, withType type: T.Type) -> T {
        if let view = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? T {
            return view
        }
        
        fatalError("Could not load view with type " + String(describing: type))
    }
}
