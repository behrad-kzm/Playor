//
//  TokenModel.swift
//  Domain
//
//  Created by Behrad Kazemi on 8/14/18.
//  Copyright © 2018 Behrad Kazemi. All rights reserved.
//

import Foundation

public enum TokenModel: InteractiveModelType {
  public struct Request: Codable {
    public let refreshToken: String
    
    public init(refreshToken: String) {
      self.refreshToken = refreshToken
    }
  }
  
  public struct Response: Codable {

    public let token: String
    public let refreshToken: String
    
    public init(AccessToken token: String, refreshToken: String) {
        self.token = token
        self.refreshToken = refreshToken
    }
  }
}
