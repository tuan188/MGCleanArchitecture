//
//  LoginUseCaseMock.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 1/16/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

@testable import CleanArchitecture
import RxSwift

final class LoginUseCaseMock: LoginUseCaseType {
    // MARK: - validate username
    
    var validateUsernameCalled = false
    var validateUsernameReturnValue = ValidationResult.valid
    
    func validate(username: String) -> ValidationResult {
        validateUsernameCalled = true
        return validateUsernameReturnValue
    }
    
    // MARK: - validate password
    
    var validatePasswordCalled = false
    var validatePasswordReturnValue = ValidationResult.valid
    
    func validate(password: String) -> ValidationResult {
        validatePasswordCalled = true
        return validatePasswordReturnValue
    }
    
    // MARK: - login
    
    var loginCalled = false
    var loginReturnValue = Observable.just(())
    
    func login(username: String, password: String) -> Observable<Void> {
        loginCalled = true
        return loginReturnValue
    }

}
