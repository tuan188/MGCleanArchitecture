//
//  LoginViewController.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 1/16/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

import UIKit
import Reusable
import Validator

final class LoginViewController: UIViewController, Bindable {
    
    // MARK: - IBOutlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var usernameValidationLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordValidationLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - Properties
    
    var viewModel: LoginViewModel!

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }

    deinit {
        logDeinit()
    }
    
    // MARK: - Methods

    private func configView() {
        usernameValidationLabel.text = ""
        passwordValidationLabel.text = ""
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
    }

    func bindViewModel() {
        let input = LoginViewModel.Input(
            usernameTrigger: usernameTextField.rx.text.orEmpty.asDriver(),
            passwordTrigger: passwordTextField.rx.text.orEmpty.asDriver(),
            loginTrigger: loginButton.rx.tap.asDriver()
        )
        
        let output = viewModel.transform(input, disposeBag: rx.disposeBag)
        
        output.$usernameValidationMessage
            .observeOn(MainScheduler.instance)
            .subscribe(usernameValidationMessageBinder)
            .disposed(by: rx.disposeBag)
        
        output.$passwordValidationMessage
            .observeOn(MainScheduler.instance)
            .subscribe(passwordValidationMessageBinder)
            .disposed(by: rx.disposeBag)
        
        output.$isLoginEnabled
            .observeOn(MainScheduler.instance)
            .subscribe(loginButton.rx.isEnabled)
            .disposed(by: rx.disposeBag)
        
        output.$isLoading
            .observeOn(MainScheduler.instance)
            .subscribe(rx.isLoading)
            .disposed(by: rx.disposeBag)
        
        output.$error
            .observeOn(MainScheduler.instance)
            .unwrap()
            .subscribe(rx.error)
            .disposed(by: rx.disposeBag)
    }
}

// MARK: - Binders
extension LoginViewController {
    var usernameValidationMessageBinder: Binder<String> {
        return Binder(self) { vc, message in
            vc.usernameValidationLabel.text = message
        }
    }
    
    var passwordValidationMessageBinder: Binder<String> {
        return Binder(self) { vc, message in
            vc.passwordValidationLabel.text = message
        }
    }
}

// MARK: - StoryboardSceneBased
extension LoginViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
