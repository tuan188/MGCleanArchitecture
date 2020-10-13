//
//  ReposViewModelTests.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/28/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

@testable import CleanArchitecture
import XCTest
import RxSwift

final class ReposViewModelTests: XCTestCase {
    private var viewModel: ReposViewModel!
    private var navigator: ReposNavigatorMock!
    private var useCase: ReposUseCaseMock!
    private var input: ReposViewModel.Input!
    private var output: ReposViewModel.Output!
    private var disposeBag: DisposeBag!

    // Triggesr
    private let loadTrigger = PublishSubject<Void>()
    private let reloadTrigger = PublishSubject<Void>()
    private let loadMoreTrigger = PublishSubject<Void>()
    private let selectRepoTrigger = PublishSubject<IndexPath>()

    override func setUp() {
        super.setUp()
        navigator = ReposNavigatorMock()
        useCase = ReposUseCaseMock()
        viewModel = ReposViewModel(navigator: navigator, useCase: useCase)
        
        input = ReposViewModel.Input(
            load: loadTrigger.asDriverOnErrorJustComplete(),
            reload: reloadTrigger.asDriverOnErrorJustComplete(),
            loadMore: loadMoreTrigger.asDriverOnErrorJustComplete(),
            selectRepo: selectRepoTrigger.asDriverOnErrorJustComplete()
        )
        
        disposeBag = DisposeBag()
        output = viewModel.transform(input, disposeBag: disposeBag)
    }

    func test_loadTriggerInvoked_getRepoList() {
        // act
        loadTrigger.onNext(())
        
        // assert
        XCTAssert(useCase.getRepoListCalled)
        XCTAssertEqual(output.repoList.count, 1)
    }

    func test_loadTriggerInvoked_getRepoList_failedShowError() {
        // arrange
        useCase.getRepoListReturnValue = Observable.error(TestError())

        // act
        loadTrigger.onNext(())

        // assert
        XCTAssert(useCase.getRepoListCalled)
        XCTAssert(output.error is TestError)
    }

    func test_reloadTriggerInvoked_getRepoList() {
        // act
        reloadTrigger.onNext(())

        // assert
        XCTAssert(useCase.getRepoListCalled)
        XCTAssertEqual(output.repoList.count, 1)
    }

    func test_reloadTriggerInvoked_getRepoList_failedShowError() {
        // arrange
        useCase.getRepoListReturnValue = Observable.error(TestError())

        // act
        reloadTrigger.onNext(())

        // assert
        XCTAssert(useCase.getRepoListCalled)
        XCTAssert(output.error is TestError)
    }

    func test_reloadTriggerInvoked_notGetRepoListIfStillLoading() {
        // arrange
        useCase.getRepoListReturnValue = Observable.never()

        // act
        loadTrigger.onNext(())
        useCase.getRepoListCalled = false
        reloadTrigger.onNext(())

        // assert
        XCTAssertFalse(useCase.getRepoListCalled)
    }

    func test_reloadTriggerInvoked_notGetRepoListIfStillReloading() {
        // arrange
        useCase.getRepoListReturnValue = Observable.never()

        // act
        reloadTrigger.onNext(())
        useCase.getRepoListCalled = false
        reloadTrigger.onNext(())

        // assert
        XCTAssertFalse(useCase.getRepoListCalled)
    }

    func test_loadMoreTriggerInvoked_loadMoreRepoList() {
        // act
        loadTrigger.onNext(())
        loadMoreTrigger.onNext(())

        // assert
        XCTAssert(useCase.getRepoListCalled)
        XCTAssertEqual(output.repoList.count, 2)
    }

    func test_loadMoreTriggerInvoked_loadMoreRepoList_failedShowError() {
        // arrange
        useCase.getRepoListReturnValue = Observable.error(TestError())

        // act
        loadTrigger.onNext(())
        loadMoreTrigger.onNext(())

        // assert
        XCTAssert(useCase.getRepoListCalled)
        XCTAssert(output.error is TestError)
    }

    func test_loadMoreTriggerInvoked_notLoadMoreRepoListIfStillLoading() {
        // arrange
        useCase.getRepoListReturnValue = Observable.never()

        // act
        loadTrigger.onNext(())
        useCase.getRepoListCalled = false
        loadMoreTrigger.onNext(())

        // assert
        XCTAssertFalse(useCase.getRepoListCalled)
    }

    func test_loadMoreTriggerInvoked_notLoadMoreRepoListIfStillReloading() {
        // arrange
        useCase.getRepoListReturnValue = Observable.never()

        // act
        reloadTrigger.onNext(())
        useCase.getRepoListCalled = false
        loadMoreTrigger.onNext(())
        
        // assert
        XCTAssertFalse(useCase.getRepoListCalled)
    }

    func test_loadMoreTriggerInvoked_notLoadMoreDocumentTypesStillLoadingMore() {
        // arrange
        useCase.getRepoListReturnValue = Observable.never()
        
        // act
        loadMoreTrigger.onNext(())
        useCase.getRepoListCalled = false
        loadMoreTrigger.onNext(())

        // assert
        XCTAssertFalse(useCase.getRepoListCalled)
    }

    func test_selectRepoTriggerInvoked_toRepoDetail() {
        // act
        loadTrigger.onNext(())
        selectRepoTrigger.onNext(IndexPath(row: 0, section: 0))

        // assert
        XCTAssert(navigator.toRepoDetailCalled)
    }
}

