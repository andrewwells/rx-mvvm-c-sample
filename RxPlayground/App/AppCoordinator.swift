//
//  AppCoordinator.swift
//  RxPlayground
//
//  Created by Andrew Wells on 11/23/17.
//  Copyright © 2017 Andrew Wells. All rights reserved.
//

import UIKit
import RxSwift

class Coordinator<ResultType> {
    
    let disposeBag = DisposeBag()
    
    typealias CoordinationResult = ResultType
    
    var rootViewController: UIViewController!
    
    var childCoordinators = [Any]()
    public func add<T>(coordinator: Coordinator<T>) {
        childCoordinators.append(coordinator)
    }
    public func remove<T>(coordinator: Coordinator<T>) {
        if let index = childCoordinators.enumerated()
            .filter( { $0.element as? Coordinator<T> === coordinator })
            .map({ $0.offset }).first {
                childCoordinators.remove(at: index)
            }
    }

    func start() -> Observable<ResultType> {
        fatalError("start Must be implemented by subclass")
    }
}

class AppCoordinator : Coordinator<Void> {
    
    override var rootViewController: UIViewController! {
        didSet {
            UIApplication.shared.keyWindow?.rootViewController = rootViewController
        }
    }
    
    override func start() -> Observable<CoordinationResult>  {
        
        if SessionManager.shared.isLoggedIn {
            self.presentMain()
        } else {
            self.presentLogin()
        }
        
        return Observable.never()
    }
    
    private func presentMain() {
        let mainCoordinator = MainCoordinator()
        mainCoordinator.start()
            .do(onNext: { [weak self] result in
                switch result {
                case .signout:
                    SessionManager.shared.currentSession = nil
                    self?.presentLogin()
                }
            })
            .take(1)
            .subscribe()
            .disposed(by: disposeBag)
        
        self.add(coordinator: mainCoordinator)
        self.rootViewController = mainCoordinator.rootViewController
    }
    
    private func presentLogin() {
        let loginCoordinator = LoginCoordinator()
        loginCoordinator
            .start()
            .observeOn(MainScheduler.instance)
            .do(onNext: { [weak self] result in
                switch result {
                case .didLogin(let session):
                    
                    SessionManager.shared.currentSession = session
                    
                    self?.remove(coordinator: loginCoordinator)
                    self?.presentMain()
                }
            })
            .take(1)
            .subscribe()
            .disposed(by: disposeBag)
        
        add(coordinator: loginCoordinator)
        self.rootViewController = loginCoordinator.rootViewController
    }
}
