//
//  UseCaseProvider.swift
//  NetworkPlatform
//
//  Created by Behrad Kazemi on 12/26/18.
//  Copyright © 2018 Behrad Kazemi. All rights reserved.
//
import Foundation
import Domain

public final class UseCaseProvider: Domain.UseCaseProvider {
    
    private let networkProvider: NetworkProvider

    public init() {
        networkProvider = NetworkProvider()
    }
    
    //MARK: - Get Token + Login
    public func makeAuthorizationUseCase() -> Domain.AuthorizationUseCase {
        return AuthorizationUseCase(network: networkProvider.makeAuthorizationNetwork())
    }
}
