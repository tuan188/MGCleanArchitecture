//
//  LoginViewController.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 1/16/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

import UIKit
import Reusable

final class LoginViewController: UIViewController, BindableType {
    
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
    }

    func bindViewModel() {
        let input = LoginViewModel.Input(
            usernameTrigger: usernameTextField.rx.text.orEmpty.asDriver(),
            passwordTrigger: passwordTextField.rx.text.orEmpty.asDriver(),
            loginTrigger: loginButton.rx.tap.asDriver()
        )
        
        let output = viewModel.transform(input)
        
        output.usernameValidation
            .drive(usernameValidationBinder)
            .disposed(by: rx.disposeBag)
        output.passwordValidation
            .drive(passwordValidationBinder)
            .disposed(by: rx.disposeBag)
        output.login
            .drive()
            .disposed(by: rx.disposeBag)
        output.isLoginEnabled
            .drive(loginButton.rx.isEnabled)
            .disposed(by: rx.disposeBag)
        output.isLoading
            .drive(rx.isLoading)
            .disposed(by: rx.disposeBag)
        output.error
            .drive(rx.error)
            .disposed(by: rx.disposeBag)
    }
}

// MARK: - Binders
extension LoginViewController {
    var usernameValidationBinder: Binder<ValidationResult> {
        return Binder(self) { vc, result in
            switch result {
            case .valid:
                vc.usernameValidationLabel.text = ""
            case let .invalid(errors):
                vc.usernameValidationLabel.text = errors.map { $0.localizedDescription }.joined(separator: "\n")
            }
        }
    }
    
    var passwordValidationBinder: Binder<ValidationResult> {
        return Binder(self) { vc, result in
            switch result {
            case .valid:
                vc.passwordValidationLabel.text = ""
            case let .invalid(errors):
                vc.passwordValidationLabel.text = errors.map { $0.localizedDescription }.joined(separator: "\n")
            }
        }
    }
}

// MARK: - StoryboardSceneBased
extension LoginViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
