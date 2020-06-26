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
import RxTest

final class AppViewModelTests: XCTestCase {
    
    private var viewModel: AppViewModel!
    private var navigator: AppNavigatorMock!
    private var useCase: AppUseCaseMock!
    
    private var input: AppViewModel.Input!
    private var output: AppViewModel.Output!
    
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    private var toMainOutput: TestableObserver<Void>!
    
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
        
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        
        toMainOutput = scheduler.createObserver(Void.self)
        output.toMain.drive(toMainOutput).disposed(by: disposeBag)
    }
    
    func test_loadTrigger_addUserData() {
        // act
        loadTrigger.onNext(())
        
        // assert
        XCTAssert(useCase.addUserDataCalled)
        XCTAssertEqual(toMainOutput.events.count, 1)
    }
}
