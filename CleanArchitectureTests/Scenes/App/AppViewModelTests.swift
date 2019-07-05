//
//  AppViewModelTests.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/4/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

@testable import CleanArchitecture
import XCTest
import RxSwift
import RxBlocking

final class AppViewModelTests: XCTestCase {
    
    private var viewModel: AppViewModel!
    private var navigator: AppNavigatorMock!
    private var useCase: AppUseCaseMock!
    
    private var input: AppViewModel.Input!
    private var output: AppViewModel.Output!
    
    private var disposeBag: DisposeBag!
    
    private let loadTrigger = PublishSubject<Void>()
    
    override func setUp() {
        super.setUp()
        navigator = AppNavigatorMock()
        useCase = AppUseCaseMock()
        viewModel = AppViewModel(navigator: navigator, useCase: useCase)
        
        input = AppViewModel.Input(
            loadTrigger: loadTrigger.asDriverOnErrorJustComplete()
        )
        
        output = viewModel.transform(input)
        
        disposeBag = DisposeBag()
        
        output.toMain.drive().disposed(by: disposeBag)
    }
    
    func test_loadTriggerInvoked_firstRun_initCoreData() {
        // arrange
        useCase.checkIfFirstRunReturnValue = true
        
        // act
        loadTrigger.onNext(())
        
        // assert
        XCTAssert(useCase.checkIfFirstRunCalled)
        XCTAssert(useCase.setDidInitCalled)
        XCTAssert(useCase.initCoreDataCalled)
    }
    
    func test_loadTriggerInvoked_notFirstRun_notInitCoreData() {
        // act
        loadTrigger.onNext(())
        
        // assert
        XCTAssert(useCase.checkIfFirstRunCalled)
        XCTAssertFalse(useCase.setDidInitCalled)
        XCTAssertFalse(useCase.initCoreDataCalled)
    }
    
    func test_loadTriggerInvoked_toMain() {
        // act
        loadTrigger.onNext(())
        
        // assert
        XCTAssert(navigator.toMainCalled)
    }
    
}
