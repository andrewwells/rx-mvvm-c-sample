//
//  MainViewModel.swift
//  RxPlayground
//
//  Created by Andrew Wells on 11/24/17.
//  Copyright © 2017 Andrew Wells. All rights reserved.
//

import Foundation
import RxSwift

protocol MainViewModelType: ViewModelType {
    var onSignOut: Observable<Void> { get }
    var signout: AnyObserver<Void> { get }
    
    var onNextButton: PublishSubject<Void> { get }
}

class MainViewModel: ViewModel, MainViewModelType {
    
    var _signout = PublishSubject<Void>()
    
    var signout: AnyObserver<Void> {
        return _signout.asObserver()
    }
    
    var onSignOut: Observable<Void> {
        return _signout.asObservable()
    }
    
    var onNextButton = PublishSubject<Void>()
}
