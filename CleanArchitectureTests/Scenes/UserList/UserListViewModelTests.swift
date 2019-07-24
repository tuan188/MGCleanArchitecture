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
import RxBlocking

final class UserListViewModelTests: XCTestCase {
    private var viewModel: UserListViewModel!
    private var navigator: UserListNavigatorMock!
    private var useCase: UserListUseCaseMock!
    
    private var input: UserListViewModel.Input!
    private var output: UserListViewModel.Output!

    private var disposeBag: DisposeBag!
    
    private let loadTrigger = PublishSubject<Void>()
    private let reloadTrigger = PublishSubject<Void>()
    private let loadMoreTrigger = PublishSubject<Void>()
    private let selectUserTrigger = PublishSubject<IndexPath>()

    override func setUp() {
        super.setUp()
        navigator = UserListNavigatorMock()
        useCase = UserListUseCaseMock()
        viewModel = UserListViewModel(navigator: navigator, useCase: useCase)
        
        input = UserListViewModel.Input(
            loadTrigger: loadTrigger.asDriverOnErrorJustComplete(),
            reloadTrigger: reloadTrigger.asDriverOnErrorJustComplete(),
            loadMoreTrigger: loadMoreTrigger.asDriverOnErrorJustComplete(),
            selectUserTrigger: selectUserTrigger.asDriverOnErrorJustComplete()
        )

        output = viewModel.transform(input)

        disposeBag = DisposeBag()
        
        output.error.drive().disposed(by: disposeBag)
        output.isLoading.drive().disposed(by: disposeBag)
        output.isReloading.drive().disposed(by: disposeBag)
        output.isLoadingMore.drive().disposed(by: disposeBag)
        output.userList.drive().disposed(by: disposeBag)
        output.selectedUser.drive().disposed(by: disposeBag)
        output.isEmpty.drive().disposed(by: disposeBag)
    }

    func test_loadTrigger_getUserList() {
        // act
        loadTrigger.onNext(())
        let userList = try? output.userList.toBlocking(timeout: 1).first()
        
        // assert
        XCTAssert(useCase.getUserListCalled)
        XCTAssertEqual(userList?.count, 1)
    }

    func test_loadTrigger_getUserList_failedShowError() {
        // arrange
        useCase.getUserListReturnValue = Observable.error(TestError())

        // act
        loadTrigger.onNext(())
        let error = try? output.error.toBlocking(timeout: 1).first()

        // assert
        XCTAssert(useCase.getUserListCalled)
        XCTAssert(error is TestError)
    }

    func test_reloadTrigger_getUserList() {
        // act
        reloadTrigger.onNext(())
        let userList = try? output.userList.toBlocking(timeout: 1).first()

        // assert
        XCTAssert(useCase.getUserListCalled)
        XCTAssertEqual(userList?.count, 1)
    }

    func test_reloadTrigger_getUserList_failedShowError() {
        // arrange
        useCase.getUserListReturnValue = Observable.error(TestError())

        // act
        reloadTrigger.onNext(())
        let error = try? output.error.toBlocking(timeout: 1).first()

        // assert
        XCTAssert(useCase.getUserListCalled)
        XCTAssert(error is TestError)
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

    func test_loadMoreTrigger_loadMoreUserList() {
        // act
        loadTrigger.onNext(())
        loadMoreTrigger.onNext(())
        let userList = try? output.userList.toBlocking(timeout: 1).first()

        // assert
        XCTAssert(useCase.getUserListCalled)
        XCTAssertEqual(userList?.count, 2)
    }

    func test_loadMoreTrigger_loadMoreUserList_failedShowError() {
        // arrange
        useCase.getUserListReturnValue = Observable.error(TestError())

        // act
        loadTrigger.onNext(())
        loadMoreTrigger.onNext(())
        let error = try? output.error.toBlocking(timeout: 1).first()

        // assert
        XCTAssert(useCase.getUserListCalled)
        XCTAssert(error is TestError)
    }

    func test_loadMoreTrigger_notLoadMoreUserListIfStillLoading() {
        // arrange
        useCase.getUserListReturnValue = Observable.never()

        // act
        loadTrigger.onNext(())
        useCase.getUserListCalled = false
        loadMoreTrigger.onNext(())

        // assert
        XCTAssertFalse(useCase.getUserListCalled)
    }

    func test_loadMoreTrigger_notLoadMoreUserListIfStillReloading() {
        // arrange
        useCase.getUserListReturnValue = Observable.never()

        // act
        reloadTrigger.onNext(())
        useCase.getUserListCalled = false
        loadMoreTrigger.onNext(())
        
        // assert
        XCTAssertFalse(useCase.getUserListCalled)
    }

    func test_loadMoreTrigger_notLoadMoreDocumentTypesStillLoadingMore() {
        // arrange
        useCase.getUserListReturnValue = Observable.never()

        // act
        loadMoreTrigger.onNext(())
        useCase.getUserListCalled = false
        loadMoreTrigger.onNext(())

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
