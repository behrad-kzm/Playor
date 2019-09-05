//
//  DataSourceType.swift
//  Domain
//
//  Created by Behrad Kazemi on 6/21/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
public enum DataSourceType: Int, Codable {
	case local = 1
	case generated = 2
	case user = 3
	case server = 4
	case bundle = 5
	case iTunes = 6
}
