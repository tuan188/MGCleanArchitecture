//
//  LoginViewModelTests.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 1/16/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

@testable import CleanArchitecture
import XCTest
import RxSwift
import RxBlocking
import RxTest

final class LoginViewModelTests: XCTestCase {
    private var viewModel: LoginViewModel!
    private var navigator: LoginNavigatorMock!
    private var useCase: LoginUseCaseMock!
    private var input: LoginViewModel.Input!
    private var output: LoginViewModel.Output!
    
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    
    private var usernameValidationOutput: TestableObserver<ValidationResult>!
    private var passwordValidationOutput: TestableObserver<ValidationResult>!
    private var loginOutput: TestableObserver<Void>!
    private var isLoginEnabledOutput: TestableObserver<Bool>!
    private var isLoadingOutput: TestableObserver<Bool>!
    private var errorOutput: TestableObserver<Error>!
    
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
        scheduler = TestScheduler(initialClock: 0)
        
        usernameValidationOutput = scheduler.createObserver(ValidationResult.self)
        passwordValidationOutput = scheduler.createObserver(ValidationResult.self)
        loginOutput = scheduler.createObserver(Void.self)
        isLoginEnabledOutput = scheduler.createObserver(Bool.self)
        isLoadingOutput = scheduler.createObserver(Bool.self)
        errorOutput = scheduler.createObserver(Error.self)
        
        output.usernameValidation.drive(usernameValidationOutput).disposed(by: disposeBag)
        output.passwordValidation.drive(passwordValidationOutput).disposed(by: disposeBag)
        output.login.drive(loginOutput).disposed(by: disposeBag)
        output.isLoginEnabled.drive(isLoginEnabledOutput).disposed(by: disposeBag)
        output.isLoading.drive(isLoadingOutput).disposed(by: disposeBag)
        output.error.drive(errorOutput).disposed(by: disposeBag)
    }
    
    private func startTriggers() {
        scheduler.createColdObservable([.next(0, "foo")])
            .bind(to: usernameTrigger)
            .disposed(by: disposeBag)
        scheduler.createColdObservable([.next(0, "bar")])
            .bind(to: passwordTrigger)
            .disposed(by: disposeBag)
        scheduler.createColdObservable([.next(10, ())])
            .bind(to: loginTrigger)
            .disposed(by: disposeBag)
        scheduler.start()
    }
    
    func test_loginTrigger_validateUsername() {
        // act
        startTriggers()
        
        // assert
        XCTAssert(useCase.validateUsernameCalled)
    }
    
    func test_loginTrigger_validatePassword() {
        // act
        startTriggers()
        
        // assert
        XCTAssert(useCase.validatePasswordCalled)
    }
    
    func test_loginTrigger_validateUsernameFailed_disableLogin() {
        // arrange
        useCase.validateUsernameReturnValue = ValidationResult.invalid([TestValidationError()])
        
        // act
        startTriggers()
        
        // assert
        XCTAssertEqual(isLoginEnabledOutput.events, [.next(0, true), .next(10, false), .next(10, false)])
        XCTAssertEqual(isLoginEnabledOutput.events.last, .next(10, false))
        XCTAssertFalse(useCase.loginCalled)
    }
    
    func test_loginTrigger_validatePasswordFailed_disableLogin() {
        // arrange
        useCase.validatePasswordReturnValue = ValidationResult.invalid([TestValidationError()])
        
        // act
        startTriggers()
        
        // assert
        XCTAssertEqual(isLoginEnabledOutput.events.last, .next(10, false))
        XCTAssertFalse(useCase.loginCalled)
    }
    
    func test_loginTrigger_login() {
        // act
        startTriggers()
        
        // assert
        XCTAssert(useCase.loginCalled)
        XCTAssert(navigator.toMainCalled)
    }
    
    func test_loginTrigger_login_showLoading() {
        // arrange
        useCase.loginReturnValue = Observable<Void>.never()
        
        // act
        startTriggers()
        
        // assert
        XCTAssert(useCase.loginCalled)
        XCTAssertEqual(isLoadingOutput.events, [.next(0, false), .next(10, true)])
        XCTAssertEqual(isLoginEnabledOutput.events.last, .next(10, false))
    }
    
    func test_loginTrigger_login_failedShowError() {
        // arrange
        useCase.loginReturnValue = Observable.error(TestError())
        
        // act
        startTriggers()
        
        // assert
        XCTAssert(useCase.loginCalled)
        XCTAssert(errorOutput.events.last?.value.element is TestError)
        XCTAssertFalse(navigator.toMainCalled)
    }
    
}
