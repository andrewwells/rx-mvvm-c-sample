//
//  AuthService.swift
//  RxPlayground
//
//  Created by Andrew Wells on 11/23/17.
//  Copyright © 2017 Andrew Wells. All rights reserved.
//

import Foundation
import RxSwift

protocol AuthServiceType {
    func signIn(username: String, password: String) -> Observable<AuthServiceSignInResult>
}

enum AuthServiceSignInResult {
    case success(Session)
    case failure
}

class MockAuthService: AuthServiceType {
    
    func signIn(username: String, password: String) -> Observable<AuthServiceSignInResult> {
        var obs: Observable<AuthServiceSignInResult>
        
        let signedIn = username == "U" && password == "P"
        if signedIn {
            let session = Session(id: "session_id", token: "session_token", name: username)
            obs = .just(.success(session))
        } else {
            obs = .just(.failure)
        }
        
        return obs.delay(2, scheduler: MainScheduler.instance)
    }
}
