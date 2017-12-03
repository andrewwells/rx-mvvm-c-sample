//
//  ViewController.swift
//  RxPlayground
//
//  Created by Andrew Wells on 11/23/17.
//  Copyright © 2017 Andrew Wells. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

protocol ViewModelType {
    
    var viewDidLoad: PublishSubject<Void>? { get set }
    
    var viewWillAppear: PublishSubject<Void>? { get set }
    var viewDidAppear: PublishSubject<Void>? { get set }
    
    var viewWillDisappear: PublishSubject<Void>? { get set }
    var viewDidDisappear: PublishSubject<Void>? { get set }
}

class ViewModel: ViewModelType {
    
    public var viewDidLoad: PublishSubject<Void>?
    
    public var viewWillAppear: PublishSubject<Void>?
    public var viewDidAppear: PublishSubject<Void>?
    
    public var viewWillDisappear: PublishSubject<Void>?
    public var viewDidDisappear: PublishSubject<Void>?
}

class ViewController: UIViewController {
    
    private let viewModel: ViewModelType
    
    let disposeBag = DisposeBag()
    
    init(viewModel: ViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init with coder not implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad?.onNext(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear?.onNext(())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewDidAppear?.onNext(())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.viewWillDisappear?.onNext(())
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDidDisappear?.onNext(())
    }

}

