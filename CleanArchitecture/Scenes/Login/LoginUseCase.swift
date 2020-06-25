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

struct LoginUseCase: LoginUseCaseType, ValidatingUserName, ValidatingPassword, LoggingIn {
    func validate(username: String) -> ValidationResult {
        return validateUserName(username)
    }
    
    func validate(password: String) -> ValidationResult {
        return validatePassword(password)
    }
}
