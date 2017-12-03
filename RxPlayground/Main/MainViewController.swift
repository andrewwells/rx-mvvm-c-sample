//
//  MainViewController.swift
//  RxPlayground
//
//  Created by Andrew Wells on 11/24/17.
//  Copyright © 2017 Andrew Wells. All rights reserved.
//

import UIKit
import RxSwift

class MainViewController: ViewController {
    
    //MARK: - Views
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "You are logged in!"
        return label
    }()
    
    lazy var signOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Out", for: .normal)
        button.rx.tap
            .bind(to: viewModel.signout)
            .disposed(by: self.disposeBag)
        return button
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.rx.tap
            .bind(to: viewModel.onNextButton)
            .disposed(by: disposeBag)
        return button
    }()
    
    private let viewModel: MainViewModelType
    
    //MARK: - Init
    
    init(viewModel: MainViewModelType) {
        self.viewModel = viewModel
        super.init(viewModel: viewModel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init with coder not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setupViews()
        
        label.text = "Hello, \(SessionManager.shared.currentSession!.name)"
    }
}

extension MainViewController {
    
    func setupViews() {
        view.addSubview(label)
        view.addSubview(nextButton)
    
        label.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: signOutButton)
    }
}
