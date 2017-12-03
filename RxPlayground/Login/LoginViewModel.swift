//
//  LoginViewModel.swift
//  RxPlayground
//
//  Created by Andrew Wells on 11/23/17.
//  Copyright © 2017 Andrew Wells. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum LoginViewState {
    case initial
    case loading
}

protocol LoginViewModelType: ViewModelType {
    
    var username: Variable<String> { get }
    var password: Variable<String> { get }
    var isValid: Observable<Bool> { get }
    
    var onSubmit: PublishSubject<Void> { get }
    
    var stateUpdated: Observable<LoginViewState> { get }
}

class LoginViewModel: ViewModel, LoginViewModelType {
    
    //MARK: - Public Properties
    
    let username = Variable<String>("")
    let password = Variable<String>("")
    let onSubmit = PublishSubject<Void>()
    
    var didLogin: Observable<Session> {
        return _didLogin.asObservable()
    }
    
    var stateUpdated: Observable<LoginViewState> {
        return _state.asObservable()
    }
    
    var isValid: Observable<Bool> {
        return Observable
            .combineLatest(self.username.asObservable(),
                           self.password.asObservable())
            { [weak self] (username, password) in
                guard let `self` = self else { return false }
                return self.validate(username: username)
                    && self.validate(password: password)
            }
    }
    
    //MARK: - Private Properties
    
    let disposeBag = DisposeBag()
    
    private let _didLogin = PublishSubject<Session>()
    
    private let _state = BehaviorSubject<LoginViewState>(value: .initial)
    
    //MARK: - Init
    
    private func updateStateOnSigninResult(result: AuthServiceSignInResult) {
        switch result {
        case .success(let session):
            self._didLogin.onNext(session)
            break
        case .failure:
            self._state.onNext(.initial)
            break
        }
    }
    
    private struct UsernameAndPasswordText { let username: String; let password: String}
    private func getUsernameAndPasswordText() -> Observable<UsernameAndPasswordText> {
        return Observable.combineLatest(username.asObservable(), password.asObservable())
            .map({ (username, password) in UsernameAndPasswordText(username: username, password: password)})
    }
    
    init(authService: AuthServiceType) {
        super.init()
        
        onSubmit
            .do(onNext: { [weak self] in self?._state.onNext(.loading) })
            .subscribe()
            .disposed(by: disposeBag)
        
        onSubmit
            .flatMap { self.getUsernameAndPasswordText() }
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap { authService.signIn(username: $0.username, password: $0.password) }
            .do(onNext: { [weak self] result in self?.updateStateOnSigninResult(result: result) })
            .subscribe()
            .disposed(by: disposeBag)
    }
}

//MARK: - Private
extension LoginViewModel {
    
    func validate(username: String) -> Bool {
        return username.count > 0
    }
    
    func validate(password: String) -> Bool {
        return password.count > 0
    }
}
