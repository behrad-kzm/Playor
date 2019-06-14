//
//  Authentication.swift
//  Domain
//
//  Created by Behrad Kazemi on 8/14/18.
//  Copyright © 2018 Behrad Kazemi. All rights reserved.
//

import Foundation
import Domain
import RxSwift

public class AuthorizationInfo {
    
    private var useCase: AuthorizationUseCase!
    public private(set) var status = AuthenticationStatus.notDetermined
    private let disposeBag = DisposeBag()
    public static let shared: AuthorizationInfo = {
        let auth = AuthorizationInfo()
        if let retrievedUUID = UserDefaults.standard.string(forKey: Constants.Keys.Authentication.UUID.rawValue) {
            auth.uuid = retrievedUUID
        } else {
            auth.uuid = UUID().uuidString
        }
        print("\n\nthe device uuid: \(auth.uuid!)")
        if let retrievedRefreshToken = UserDefaults.standard.string(forKey: Constants.Keys.Authentication.refreshToken.rawValue){
            if retrievedRefreshToken != ""{
                auth.status = .loggedIn
                auth.refreshToken = retrievedRefreshToken
                auth.accessToken = UserDefaults.standard.string(forKey: Constants.Keys.Authentication.accessToken.rawValue) ?? ""
                return auth
            }
				}else{
					auth.accessToken = String()
			}
        return auth
    }()
  
    public private(set) var uuid: String! {
        didSet {
            UserDefaults.standard.set(uuid, forKey: Constants.Keys.Authentication.UUID.rawValue)
        }
    }
    public private(set) var accessToken: String! {
        didSet {
            UserDefaults.standard.set(accessToken, forKey: Constants.Keys.Authentication.accessToken.rawValue)
        }
    }
    public private(set) var refreshToken: String! {
        didSet {
            UserDefaults.standard.set(refreshToken, forKey: Constants.Keys.Authentication.refreshToken.rawValue)
        }
    }
    
    public func tokenExpirationHandler(response: HTTPURLResponse) {
        if response.url?.absoluteString == Constants.EndPoints.tokenUrl.rawValue {
            return
        }
        _ = getNewToken()
    }
    
    public func loggendIn(token: TokenModel.Response) {
        accessToken = token.token
        refreshToken = token.refreshToken
        status = .loggedIn
        print("Token: \n \'Bearer \(accessToken ?? "null")\'")
    }
    
    public func LoggedOut(completion: @escaping ()->()) {
        accessToken = ""
        refreshToken = ""
        status = .notDetermined
        
        completion()
    }
    
    public func getNewToken() -> Observable<Bool>{
        let request = TokenModel.Request(refreshToken: refreshToken)
        let result = NetworkProvider().makeAuthorizationNetwork().getToken(requestParameter: request)
        result.subscribe(onNext: { [unowned self] (response) in
            self.accessToken = response.token
            self.refreshToken = response.refreshToken
            self.status = .loggedIn
            print("Token: \n \'Bearer \(self.accessToken ?? "null")\'")
        }, onError: { (error) in
            self.status = .tokenExpired
            print(error)
        }).disposed(by: disposeBag)
        return result.map{_ in return true}
    }
}
