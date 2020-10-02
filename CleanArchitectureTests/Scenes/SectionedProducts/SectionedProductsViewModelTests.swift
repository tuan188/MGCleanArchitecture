//
//  SectionedProductsViewModelTests.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/11/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

@testable import CleanArchitecture
import XCTest
import RxSwift
    
final class SectionedProductsViewModelTests: XCTestCase {
    private var viewModel: SectionedProductsViewModel!
    private var navigator: SectionedProductsNavigatorMock!
    private var useCase: SectionedProductsUseCaseMock!
    
    private var input: SectionedProductsViewModel.Input!
    private var output: SectionedProductsViewModel.Output!
    
    private var disposeBag: DisposeBag!
    
    private let loadTrigger = PublishSubject<Void>()
    private let reloadTrigger = PublishSubject<Void>()
    private let loadMoreTrigger = PublishSubject<Void>()
    private let selectProductTrigger = PublishSubject<IndexPath>()
    private let editProductTrigger = PublishSubject<IndexPath>()
    private let updatedProductTrigger = PublishSubject<Product>()

    override func setUp() {
        super.setUp()
        navigator = SectionedProductsNavigatorMock()
        useCase = SectionedProductsUseCaseMock()
        viewModel = SectionedProductsViewModel(navigator: navigator, useCase: useCase)
        
        input = SectionedProductsViewModel.Input(
            loadTrigger: loadTrigger.asDriverOnErrorJustComplete(),
            reloadTrigger: reloadTrigger.asDriverOnErrorJustComplete(),
            loadMoreTrigger: loadMoreTrigger.asDriverOnErrorJustComplete(),
            selectProductTrigger: selectProductTrigger.asDriverOnErrorJustComplete(),
            editProductTrigger: editProductTrigger.asDriverOnErrorJustComplete(),
            updatedProductTrigger: updatedProductTrigger.asDriverOnErrorJustComplete()
        )
        
        disposeBag = DisposeBag()
        output = viewModel.transform(input, disposeBag: disposeBag)
    }

    func test_loadTriggerInvoked_getProductList() {
        // act
        loadTrigger.onNext(())
        
        // assert
        XCTAssert(useCase.getProductListCalled)
        XCTAssertEqual(output.productSections.count, 1)
        XCTAssertEqual(output.productSections[0].productList.count, 1)
    }

    func test_loadTriggerInvoked_getProductList_failedShowError() {
        // arrange
        useCase.getProductListReturnValue = Observable.error(TestError())

        // act
        loadTrigger.onNext(())

        // assert
        XCTAssert(useCase.getProductListCalled)
        XCTAssert(output.error is TestError)
    }

    func test_reloadTriggerInvoked_getProductList() {
        // act
        reloadTrigger.onNext(())

        // assert
        XCTAssert(useCase.getProductListCalled)
        XCTAssertEqual(output.productSections.count, 1)
        XCTAssertEqual(output.productSections[0].productList.count, 1)
    }

    func test_reloadTriggerInvoked_getProductList_failedShowError() {
        // arrange
        useCase.getProductListReturnValue = Observable.error(TestError())

        // act
        reloadTrigger.onNext(())

        // assert
        XCTAssert(useCase.getProductListCalled)
        XCTAssert(output.error is TestError)
    }

    func test_reloadTriggerInvoked_notGetProductListIfStillLoading() {
        // arrange
        useCase.getProductListReturnValue = Observable.never()

        // act
        loadTrigger.onNext(())
        useCase.getProductListCalled = false
        reloadTrigger.onNext(())

        // assert
        XCTAssertFalse(useCase.getProductListCalled)
    }

    func test_reloadTriggerInvoked_notGetProductListIfStillReloading() {
        // arrange
        useCase.getProductListReturnValue = Observable.never()

        // act
        reloadTrigger.onNext(())
        useCase.getProductListCalled = false
        reloadTrigger.onNext(())

        // assert
        XCTAssertFalse(useCase.getProductListCalled)
    }

    func test_loadMoreTriggerInvoked_loadMoreProductList() {
        // act
        loadTrigger.onNext(())
        loadMoreTrigger.onNext(())

        // assert
        XCTAssert(useCase.getProductListCalled)
        XCTAssertEqual(output.productSections.count, 1)
        XCTAssertEqual(output.productSections[0].productList.count, 2)
    }

    func test_loadMoreTriggerInvoked_loadMoreProductList_failedShowError() {
        // arrange
        useCase.getProductListReturnValue = Observable.error(TestError())

        // act
        loadTrigger.onNext(())
        loadMoreTrigger.onNext(())

        // assert
        XCTAssert(useCase.getProductListCalled)
        XCTAssert(output.error is TestError)
    }

    func test_loadMoreTriggerInvoked_notLoadMoreProductListIfStillLoading() {
        // arrange
        useCase.getProductListReturnValue = Observable.never()

        // act
        loadTrigger.onNext(())
        useCase.getProductListCalled = false
        loadMoreTrigger.onNext(())

        // assert
        XCTAssertFalse(useCase.getProductListCalled)
    }

    func test_loadMoreTriggerInvoked_notLoadMoreProductListIfStillReloading() {
        // arrange
        useCase.getProductListReturnValue = Observable.never()

        // act
        reloadTrigger.onNext(())
        useCase.getProductListCalled = false
        loadMoreTrigger.onNext(())
        
        // assert
        XCTAssertFalse(useCase.getProductListCalled)
    }

    func test_loadMoreTriggerInvoked_notLoadMoreDocumentTypesStillLoadingMore() {
        // arrange
        useCase.getProductListReturnValue = Observable.never()

        // act
        loadMoreTrigger.onNext(())
        useCase.getProductListCalled = false
        loadMoreTrigger.onNext(())

        // assert
        XCTAssertFalse(useCase.getProductListCalled)
    }

    func test_selectProductTriggerInvoked_toProductDetail() {
        // act
        loadTrigger.onNext(())
        selectProductTrigger.onNext(IndexPath(row: 0, section: 0))

        // assert
        XCTAssert(navigator.toProductDetailCalled)
    }
}

