//
//  AuthorizationUseCase.swift
//  NetworkPlatform
//
//  Created by Salar Soleimani on 8/15/18.
//  Copyright © 2018 Behrad Kazemi. All rights reserved.
//

import RxSwift
import Domain

public final class AuthorizationUseCase: Domain.AuthorizationUseCase {

  private let network: AuthenticationNetwork
  
  init(network: AuthenticationNetwork) {
    self.network = network
  }
  
  public func getToken(requestParameter: TokenModel.Request) -> Observable<TokenModel.Response> {
    return network.getToken(requestParameter: requestParameter)
  }
}
