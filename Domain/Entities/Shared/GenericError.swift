//
//  GenericError.swift
//  Domain
//
//  Created by Behrad Kazemi on 8/29/18.
//  Copyright © 2018 Behrad Kazemi. All rights reserved.
//

import Foundation
public enum ResponseMessage {
  public struct Base: Codable {
    public let code: Int
    public let message: String
  }
}
