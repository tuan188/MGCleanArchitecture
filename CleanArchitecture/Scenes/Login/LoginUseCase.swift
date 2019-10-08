//
//  LoginUseCase.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 1/16/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

protocol LoginUseCaseType {
    func validate(username: String) -> ValidationResult
    func validate(password: String) -> ValidationResult
    func login(username: String, password: String) -> Observable<Void>
}

struct LoginUseCase: LoginUseCaseType {
    func validate(username: String) -> ValidationResult {
        let minLengthRule = ValidationRuleLength(min: 1, error: LoginValidationError.usernameMinLength)
        return username.validate(rule: minLengthRule)
    }
    
    func validate(password: String) -> ValidationResult {
        let minLengthRule = ValidationRuleLength(min: 1, error: LoginValidationError.passwordMinLength)
        return password.validate(rule: minLengthRule)
    }
    
    func login(username: String, password: String) -> Observable<Void> {
        return Observable.create { observer in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5, execute: {
                observer.onNext(())
                observer.onCompleted()
            })
            return Disposables.create()
        }
    }
}
