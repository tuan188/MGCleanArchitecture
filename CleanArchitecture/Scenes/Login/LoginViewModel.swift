//
//  LoginViewModel.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 1/16/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

import ValidatedPropertyKit
import RxSwift
import RxCocoa
import MGArchitecture

struct LoginViewModel {
    let navigator: LoginNavigatorType
    let useCase: LoginUseCaseType
}

// MARK: - ViewModel
extension LoginViewModel: ViewModel {
    struct Input {
        let usernameTrigger: Driver<String>
        let passwordTrigger: Driver<String>
        let loginTrigger: Driver<Void>
    }

    struct Output {
        @Property var usernameValidationMessage = ""
        @Property var passwordValidationMessage = ""
        @Property var isLoginEnabled = true
        @Property var isLoading = false
        @Property var error: Error?
    }

    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        let errorTracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()
        
        errorTracker
            .drive(output.$error)
            .disposed(by: disposeBag)
        
        let isLoading = activityIndicator.asDriver()
        
        isLoading
            .drive(output.$isLoading)
            .disposed(by: disposeBag)
        
        let usernameValidation = Driver.combineLatest(input.usernameTrigger, input.loginTrigger)
            .map { $0.0 }
            .map(useCase.validateUserName(_:))
        
        usernameValidation
            .map { $0.message }
            .drive(output.$usernameValidationMessage)
            .disposed(by: disposeBag)
  
        let passwordValidation = Driver.combineLatest(input.passwordTrigger, input.loginTrigger)
            .map { $0.0 }
            .map(useCase.validatePassword(_:))
        
        passwordValidation
            .map { $0.message }
            .drive(output.$passwordValidationMessage)
            .disposed(by: disposeBag)
        
        let validation = Driver.and(
            usernameValidation.map { $0.isValid },
            passwordValidation.map { $0.isValid }
        )
        .startWith(true)
        
        let isLoginEnabled = Driver.merge(validation, isLoading.not())
        
        isLoginEnabled
            .drive(output.$isLoginEnabled)
            .disposed(by: disposeBag)
        
        input.loginTrigger
            .withLatestFrom(isLoginEnabled)
            .filter { $0 }
            .withLatestFrom(Driver.combineLatest(input.usernameTrigger, input.passwordTrigger))
            .flatMapLatest { username, password -> Driver<Void> in
                self.useCase.login(dto: LoginDto(username: username, password: password))
                    .trackError(errorTracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
            }
            .do(onNext: navigator.toMain)
            .drive()
            .disposed(by: disposeBag)
        
        return output
    }
}
