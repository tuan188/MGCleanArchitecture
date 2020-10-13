//
//  UserListViewModelTests.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 1/14/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

@testable import CleanArchitecture
import XCTest
import RxSwift

final class UserListViewModelTests: XCTestCase {
    private var viewModel: UserListViewModel!
    private var navigator: UserListNavigatorMock!
    private var useCase: UserListUseCaseMock!
    
    private var input: UserListViewModel.Input!
    private var output: UserListViewModel.Output!

    private var disposeBag: DisposeBag!
    
    private let loadTrigger = PublishSubject<Void>()
    private let reloadTrigger = PublishSubject<Void>()
    private let selectUserTrigger = PublishSubject<IndexPath>()

    override func setUp() {
        super.setUp()
        navigator = UserListNavigatorMock()
        useCase = UserListUseCaseMock()
        viewModel = UserListViewModel(navigator: navigator, useCase: useCase)
        
        input = UserListViewModel.Input(
            load: loadTrigger.asDriverOnErrorJustComplete(),
            reload: reloadTrigger.asDriverOnErrorJustComplete(),
            selectUser: selectUserTrigger.asDriverOnErrorJustComplete()
        )

        disposeBag = DisposeBag()
        output = viewModel.transform(input, disposeBag: disposeBag)
    }

    func test_loadTrigger_getUserList() {
        // act
        loadTrigger.onNext(())
        
        // assert
        XCTAssert(useCase.getUserListCalled)
        XCTAssertEqual(output.userList.count, 1)
    }

    func test_loadTrigger_getUserList_failedShowError() {
        // arrange
        useCase.getUserListReturnValue = Observable.error(TestError())

        // act
        loadTrigger.onNext(())

        // assert
        XCTAssert(useCase.getUserListCalled)
        XCTAssert(output.error is TestError)
    }

    func test_reloadTrigger_getUserList() {
        // act
        reloadTrigger.onNext(())

        // assert
        XCTAssert(useCase.getUserListCalled)
        XCTAssertEqual(output.userList.count, 1)
    }

    func test_reloadTrigger_getUserList_failedShowError() {
        // arrange
        useCase.getUserListReturnValue = Observable.error(TestError())

        // act
        reloadTrigger.onNext(())

        // assert
        XCTAssert(useCase.getUserListCalled)
        XCTAssert(output.error is TestError)
    }

    func test_reloadTrigger_notGetUserListIfStillLoading() {
        // arrange
        useCase.getUserListReturnValue = Observable.never()

        // act
        loadTrigger.onNext(())
        useCase.getUserListCalled = false
        reloadTrigger.onNext(())

        // assert
        XCTAssertFalse(useCase.getUserListCalled)
    }

    func test_reloadTrigger_notGetUserListIfStillReloading() {
        // arrange
        useCase.getUserListReturnValue = Observable.never()

        // act
        reloadTrigger.onNext(())
        useCase.getUserListCalled = false
        reloadTrigger.onNext(())

        // assert
        XCTAssertFalse(useCase.getUserListCalled)
    }

    func test_selectUserTrigger_toUserDetail() {
        // act
        loadTrigger.onNext(())
        selectUserTrigger.onNext(IndexPath(row: 0, section: 0))

        // assert
        XCTAssert(navigator.toUserDetailCalled)
    }
}
