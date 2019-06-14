//
//  UseCaseProvider.swift
//  Domain
//
//  Created by Behrad Kazemi on 8/15/18.
//  Copyright © 2018 Behrad Kazemi. All rights reserved.
//

import Foundation

public protocol UseCaseProvider {
    
    //MARK: - Get Token + Login
    func makeAuthorizationUseCase() -> AuthorizationUseCase
}
