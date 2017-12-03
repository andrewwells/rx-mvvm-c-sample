//
//  LoginViewController.swift
//  RxPlayground
//
//  Created by Andrew Wells on 11/23/17.
//  Copyright © 2017 Andrew Wells. All rights reserved.
//

import UIKit
import RxSwift

class LoginViewController: ViewController {
    
    //MARK: - Public Properties
    
    //MARK: - Private Properties
    
    private let viewModel: LoginViewModelType
    
    private var loadingView: UIView?
    
    //MARK: - Views
    
    private lazy var userNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter Username"
        return tf
    }()
    
    private lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter Password"
        return tf
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 4
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    //MARK: - Init
    
    init(viewModel: LoginViewModelType) {
        self.viewModel = viewModel
        super.init(viewModel: viewModel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init with coder not implemented")
    }
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    
        setupViews()
        bindViews()
        bindState()
    }
}

//MARK: - Private
private extension LoginViewController {
    
    func setupViews() {
        
        view.addSubview(userNameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(submitButton)
        
        userNameTextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        passwordTextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(userNameTextField)
            make.top.equalTo(userNameTextField.snp.bottom).offset(20)
        }
        
        submitButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(userNameTextField)
            make.top.equalTo(passwordTextField.snp.bottom).offset(50)
            make.height.equalTo(50)
        }
    }
    
    func bindViews() {
        
        userNameTextField.rx.text
            .orEmpty
            .bind(to: viewModel.username)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        viewModel.isValid
            .map { $0 }
            .do(onNext: { [weak self] isValid in
                
                UIView.animate(withDuration: 0.3, animations: {
                    self?.submitButton.backgroundColor = isValid ? UIColor.init(hexString: "#00B200") : .lightGray
                })
                
                self?.submitButton.isEnabled = isValid
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        submitButton.rx.tap
            .throttle(0.5, scheduler: MainScheduler.instance)
            .bind(to: viewModel.onSubmit)
            .disposed(by: disposeBag)
    }
    
    func bindState() {
        
        viewModel.stateUpdated
            .observeOn(MainScheduler.instance)
            .do(onNext: { [weak self] state in
                
                switch state {
                case .initial: self?.hideLoadingView(animated: true)
                case .loading:
                    self?.view.endEditing(true)
                    self?.showLoadingView(animated: true)
                }
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    func hideLoadingView(animated: Bool) {
        
        let hideAction = {
            self.loadingView?.removeFromSuperview()
            self.loadingView = nil
        }
        
        if !animated {
            hideAction()
            return
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.loadingView?.alpha = 0
        }) { finished in
            if finished {
                hideAction()
            }
        }
    }
    
    func showLoadingView(animated: Bool) {
        
        if self.loadingView != nil {
            return
        }
        
        let spinnerView = UIView()
        spinnerView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        let activity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activity.startAnimating()
        
        spinnerView.addSubview(activity)
        activity.snp.makeConstraints({ (make) in
            make.center.equalToSuperview()
        })
        
        self.view.addSubview(spinnerView)
        spinnerView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
        self.loadingView = spinnerView
        
        if !animated { return }
        
        spinnerView.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            spinnerView.alpha = 1
        })
    }
}
