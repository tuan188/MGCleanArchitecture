//
//  LoginUseCase.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 1/16/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

import Dto
import RxSwift
import ValidatedPropertyKit

protocol LoginUseCaseType {
    func validateUserName(_ username: String) -> ValidationResult
    func validatePassword(_ password: String) -> ValidationResult
    func login(dto: LoginDto) -> Observable<Void>
}

struct LoginUseCase: LoginUseCaseType, LoggingIn {
    func validateUserName(_ username: String) -> ValidationResult {
        return LoginDto.validateUserName(username).mapToVoid()
    }
    
    func validatePassword(_ password: String) -> ValidationResult {
        return LoginDto.validatePassword(password).mapToVoid()
    }
}
