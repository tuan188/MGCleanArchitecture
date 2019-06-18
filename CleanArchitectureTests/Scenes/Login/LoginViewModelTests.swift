//
// LoginViewModelTests.swift
// CleanArchitecture
//
// Created by Tuan Truong on 1/16/19.
// Copyright © 2019 Framgia. All rights reserved.
//

@testable import CleanArchitecture
import XCTest
import RxSwift
import RxBlocking

final class LoginViewModelTests: XCTestCase {
    private var viewModel: LoginViewModel!
    private var navigator: LoginNavigatorMock!
    private var useCase: LoginUseCaseMock!
    
    private var input: LoginViewModel.Input!
    private var output: LoginViewModel.Output!
    
    private var disposeBag: DisposeBag!
    
    private let usernameTrigger = PublishSubject<String>()
    private let passwordTrigger = PublishSubject<String>()
    private let loginTrigger = PublishSubject<Void>()
    
    override func setUp() {
        super.setUp()
        navigator = LoginNavigatorMock()
        useCase = LoginUseCaseMock()
        viewModel = LoginViewModel(navigator: navigator, useCase: useCase)
        
        input = LoginViewModel.Input(
            usernameTrigger: usernameTrigger.asDriverOnErrorJustComplete(),
            passwordTrigger: passwordTrigger.asDriverOnErrorJustComplete(),
            loginTrigger: loginTrigger.asDriverOnErrorJustComplete()
        )
        
        output = viewModel.transform(input)
        
        disposeBag = DisposeBag()
        
        output.usernameValidation.drive().disposed(by: disposeBag)
        output.passwordValidation.drive().disposed(by: disposeBag)
        output.login.drive().disposed(by: disposeBag)
        output.isLoginEnabled.drive().disposed(by: disposeBag)
        output.isLoading.drive().disposed(by: disposeBag)
        output.error.drive().disposed(by: disposeBag)
    }
    
    func test_loginTrigger_validateUsername() {
        // act
        usernameTrigger.onNext("")
        loginTrigger.onNext(())
        
        // assert
        XCTAssert(useCase.validateUsernameCalled)
    }
    
    func test_loginTrigger_validatePassword() {
        // act
        passwordTrigger.onNext("")
        loginTrigger.onNext(())
        
        // assert
        XCTAssert(useCase.validatePasswordCalled)
    }
    
    func test_loginTrigger_validateUsernameFailed_disableLogin() {
        // arrange
        useCase.validateUsernameReturnValue = ValidationResult.invalid([TestError()])
        
        // act
        usernameTrigger.onNext("")
        passwordTrigger.onNext("")
        loginTrigger.onNext(())
        
        let loginEnabled = try? output.isLoginEnabled.toBlocking(timeout: 1).first()
        
        // assert
        XCTAssertEqual(loginEnabled, false)
    }
    
    func test_loginTrigger_validatePasswordFailed_disableLogin() {
        // arrange
        useCase.validatePasswordReturnValue = ValidationResult.invalid([TestError()])
        
        // act
        usernameTrigger.onNext("")
        passwordTrigger.onNext("")
        loginTrigger.onNext(())
        
        let loginEnabled = try? output.isLoginEnabled.toBlocking(timeout: 1).first()
        
        // assert
        XCTAssertEqual(loginEnabled, false)
    }
    
    func test_loginTrigger_disableLogin_notLogin() {
        // arrange
        useCase.validatePasswordReturnValue = ValidationResult.invalid([TestError()])
        
        // act
        usernameTrigger.onNext("")
        passwordTrigger.onNext("")
        loginTrigger.onNext(())
        
        // assert
        XCTAssertFalse(useCase.loginCalled)
    }
    
    func test_loginTrigger_login() {
        // act
        usernameTrigger.onNext("")
        passwordTrigger.onNext("")
        loginTrigger.onNext(())
        
        // assert
        XCTAssert(useCase.loginCalled)
        XCTAssert(navigator.toMainCalled)
    }
    
    func test_loginTrigger_login_showLoading() {
        // arrange
        useCase.loginReturnValue = Observable<Void>.never()
        
        // act
        usernameTrigger.onNext("")
        passwordTrigger.onNext("")
        loginTrigger.onNext(())
        
        let isLoading = try? output.isLoading.toBlocking(timeout: 1).first()
        
        // assert
        XCTAssert(useCase.loginCalled)
        XCTAssertEqual(isLoading, true)
    }
    
    func test_loginTrigger_loading_disableLogin() {
        // arrange
        useCase.loginReturnValue = Observable<Void>.never()
        
        // act
        usernameTrigger.onNext("")
        passwordTrigger.onNext("")
        loginTrigger.onNext(())
        
        let isLoading = try? output.isLoading.toBlocking(timeout: 1).first()
        let isLoginEnabled = try? output.isLoginEnabled.toBlocking(timeout: 1).first()
        
        // assert
        XCTAssert(useCase.loginCalled)
        XCTAssertEqual(isLoading, true)
        XCTAssertEqual(isLoginEnabled, false)
    }
    
    func test_loginTrigger_login_failedShowError() {
        // arrange
        useCase.loginReturnValue = Observable.error(TestError())
        
        // act
        usernameTrigger.onNext("")
        passwordTrigger.onNext("")
        loginTrigger.onNext(())
        
        let error = try? output.error.toBlocking(timeout: 1).first()
        
        // assert
        XCTAssert(useCase.loginCalled)
        XCTAssert(error is TestError)
        XCTAssertFalse(navigator.toMainCalled)
    }
    
}
