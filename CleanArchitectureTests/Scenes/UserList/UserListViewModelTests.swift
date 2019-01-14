//
// UserListViewModelTests.swift
// CleanArchitecture
//
// Created by Tuan Truong on 1/14/19.
// Copyright © 2019 Framgia. All rights reserved.
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
        output.loading.drive().disposed(by: disposeBag)
        output.refreshing.drive().disposed(by: disposeBag)
        output.loadingMore.drive().disposed(by: disposeBag)
        output.fetchItems.drive().disposed(by: disposeBag)
        output.userList.drive().disposed(by: disposeBag)
        output.selectedUser.drive().disposed(by: disposeBag)
        output.isEmptyData.drive().disposed(by: disposeBag)
    }

    func test_loadTrigger_getUserList() {
        // act
        loadTrigger.onNext(())
        let userList = try? output.userList.toBlocking(timeout: 1).first()
        
        // assert
        XCTAssert(useCase.getUserListCalled)
        XCTAssertEqual(userList??.count, 1)
    }

    func test_loadTrigger_getUserList_failedShowError() {
        // arrange
        let getUserListReturnValue = PublishSubject<PagingInfo<User>>()
        useCase.getUserListReturnValue = getUserListReturnValue

        // act
        loadTrigger.onNext(())
        getUserListReturnValue.onError(TestError())
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
        XCTAssertEqual(userList??.count, 1)
    }

    func test_reloadTrigger_getUserList_failedShowError() {
        // arrange
        let getUserListReturnValue = PublishSubject<PagingInfo<User>>()
        useCase.getUserListReturnValue = getUserListReturnValue

        // act
        reloadTrigger.onNext(())
        getUserListReturnValue.onError(TestError())
        let error = try? output.error.toBlocking(timeout: 1).first()

        // assert
        XCTAssert(useCase.getUserListCalled)
        XCTAssert(error is TestError)
    }

    func test_reloadTrigger_notGetUserListIfStillLoading() {
        // arrange
        let getUserListReturnValue = PublishSubject<PagingInfo<User>>()
        useCase.getUserListReturnValue = getUserListReturnValue

        // act
        loadTrigger.onNext(())
        useCase.getUserListCalled = false
        reloadTrigger.onNext(())

        // assert
        XCTAssertFalse(useCase.getUserListCalled)
    }

    func test_reloadTrigger_notGetUserListIfStillReloading() {
        // arrange
        let getUserListReturnValue = PublishSubject<PagingInfo<User>>()
        useCase.getUserListReturnValue = getUserListReturnValue

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
        XCTAssert(useCase.loadMoreUserListCalled)
        XCTAssertEqual(userList??.count, 2)
    }

    func test_loadMoreTrigger_loadMoreUserList_failedShowError() {
        // arrange
        let loadMoreUserListReturnValue = PublishSubject<PagingInfo<User>>()
        useCase.loadMoreUserListReturnValue = loadMoreUserListReturnValue

        // act
        loadTrigger.onNext(())
        loadMoreTrigger.onNext(())
        loadMoreUserListReturnValue.onError(TestError())
        let error = try? output.error.toBlocking(timeout: 1).first()

        // assert
        XCTAssert(useCase.loadMoreUserListCalled)
        XCTAssert(error is TestError)
    }

    func test_loadMoreTrigger_notLoadMoreUserListIfStillLoading() {
        // arrange
        let getUserListReturnValue = PublishSubject<PagingInfo<User>>()
        useCase.getUserListReturnValue = getUserListReturnValue

        // act
        loadTrigger.onNext(())
        useCase.getUserListCalled = false
        loadMoreTrigger.onNext(())

        // assert
        XCTAssertFalse(useCase.loadMoreUserListCalled)
    }

    func test_loadMoreTrigger_notLoadMoreUserListIfStillReloading() {
        // arrange
        let getUserListReturnValue = PublishSubject<PagingInfo<User>>()
        useCase.getUserListReturnValue = getUserListReturnValue

        // act
        reloadTrigger.onNext(())
        useCase.getUserListCalled = false
        loadMoreTrigger.onNext(())
        // assert
        XCTAssertFalse(useCase.loadMoreUserListCalled)
    }

    func test_loadMoreTrigger_notLoadMoreDocumentTypesStillLoadingMore() {
        // arrange
        let loadMoreUserListReturnValue = PublishSubject<PagingInfo<User>>()
        useCase.loadMoreUserListReturnValue = loadMoreUserListReturnValue

        // act
        loadMoreTrigger.onNext(())
        useCase.loadMoreUserListCalled = false
        loadMoreTrigger.onNext(())

        // assert
        XCTAssertFalse(useCase.loadMoreUserListCalled)
    }

    func test_selectUserTrigger_toUserDetail() {
        // act
        loadTrigger.onNext(())
        selectUserTrigger.onNext(IndexPath(row: 0, section: 0))

        // assert
        XCTAssert(navigator.toUserDetailCalled)
    }
}