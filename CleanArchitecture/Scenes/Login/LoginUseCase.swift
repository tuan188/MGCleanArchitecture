//
//  LoginUseCase.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 1/16/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

import ValidatedPropertyKit

protocol LoginUseCaseType {
    func validateUserName(_ username: String) -> Result<String, ValidationError>
    func validatePassword(_ password: String) -> Result<String, ValidationError>
    func login(dto: LoginDto) -> Observable<Void>
}

struct LoginUseCase: LoginUseCaseType, LoggingIn {
    func validateUserName(_ username: String) -> Result<String, ValidationError> {
        return LoginDto.validateUserName(username)
    }
    
    func validatePassword(_ password: String) -> Result<String, ValidationError> {
        return LoginDto.validatePassword(password)
    }
}
