//
//  MainCoordinator.swift
//  RxPlayground
//
//  Created by Andrew Wells on 11/24/17.
//  Copyright © 2017 Andrew Wells. All rights reserved.
//

import Foundation
import RxSwift

enum MainCoordinatorResult {
    case signout
}

class MainCoordinator: Coordinator<MainCoordinatorResult> {
    
    private var navigationController: UINavigationController! {
        didSet {
            rootViewController = navigationController
        }
    }
    
    override func start() -> Observable<MainCoordinatorResult> {
        
        let viewModel = MainViewModel()
        navigationController = UINavigationController(rootViewController: MainViewController(viewModel: viewModel))
        
        let signout = viewModel.onSignOut
            .flatMap({ () -> Observable<MainCoordinatorResult> in
                return .just(.signout)
            })
        
        viewModel.onNextButton
            .throttle(0.5, scheduler: MainScheduler.instance)
            .do(onNext: { [weak self] in
                let vc = UIViewController()
                vc.view.backgroundColor = .white
                self?.navigationController.pushViewController(vc, animated: true)
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        
        return signout
    }
}
