//
//  AuthenticationNetwork.swift
//  NetworkPlatform
//
//  Created by Behrad Kazemi on 8/14/18.
//  Copyright © 2018 Behrad Kazemi. All rights reserved.
//

import Domain
import RxSwift

public final class AuthenticationNetwork {
  
  private let network: Network<TokenModel.Response>
  
  init(network: Network<TokenModel.Response>) {
    self.network = network
  }
  
  public func getToken(requestParameter: TokenModel.Request) -> Observable<TokenModel.Response> {
    return network.putItem(Constants.EndPoints.tokenUrl.rawValue, parameters:  requestParameter.dictionary!)
  }
  
}
