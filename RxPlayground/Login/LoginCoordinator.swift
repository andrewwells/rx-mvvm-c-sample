//
//  LoginCoordinator.swift
//  RxPlayground
//
//  Created by Andrew Wells on 11/24/17.
//  Copyright © 2017 Andrew Wells. All rights reserved.
//

import UIKit
import RxSwift

enum LoginCoordinatorResult {
    case didLogin(Session)
}

class LoginCoordinator: Coordinator<LoginCoordinatorResult> {
    
    override func start() -> Observable<LoginCoordinatorResult> {
        
        let loginViewModel = LoginViewModel(authService: MockAuthService())
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        self.rootViewController = loginViewController
        
        return loginViewModel
            .didLogin
            .flatMap({ session -> Observable<LoginCoordinatorResult> in
                return .just(.didLogin(session))
            })
    }
}
