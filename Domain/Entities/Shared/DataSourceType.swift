//
//  DataSourceType.swift
//  Domain
//
//  Created by Behrad Kazemi on 6/21/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
public enum DataSourceType: Int, Codable {
	case local
	case generated
	case user
	case server
}
