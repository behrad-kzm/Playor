//
//  AuthorizationUseCase.swift
//  Domain
//
//  Created by Behrad Kazemi on 8/15/18.
//  Copyright © 2018 Behrad Kazemi. All rights reserved.
//

import Foundation
import RxSwift

public protocol AuthorizationUseCase {
  func getToken(requestParameter: TokenModel.Request) -> Observable<TokenModel.Response>
}
