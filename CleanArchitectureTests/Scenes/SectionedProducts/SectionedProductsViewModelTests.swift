//
// SectionedProductsViewModelTests.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/11/18.
// Copyright © 2018 Framgia. All rights reserved.
//

@testable import CleanArchitecture
import XCTest
import RxSwift
import RxBlocking

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
        
        output = viewModel.transform(input)
        
        disposeBag = DisposeBag()
        
        output.error.drive().disposed(by: disposeBag)
        output.loading.drive().disposed(by: disposeBag)
        output.refreshing.drive().disposed(by: disposeBag)
        output.loadingMore.drive().disposed(by: disposeBag)
        output.fetchItems.drive().disposed(by: disposeBag)
        output.productSections.drive().disposed(by: disposeBag)
        output.selectedProduct.drive().disposed(by: disposeBag)
        output.isEmptyData.drive().disposed(by: disposeBag)
    }

    func test_loadTriggerInvoked_getProductList() {
        // act
        loadTrigger.onNext(())
        let productSections = try? output.productSections.toBlocking(timeout: 1).first()
        
        // assert
        XCTAssert(useCase.getProductList_Called)
        XCTAssertEqual(productSections??[0].productList.count, 1)
    }

    func test_loadTriggerInvoked_getProductList_failedShowError() {
        // arrange
        let getProductList_ReturnValue = PublishSubject<PagingInfo<Product>>()
        useCase.getProductList_ReturnValue = getProductList_ReturnValue

        // act
        loadTrigger.onNext(())
        getProductList_ReturnValue.onError(TestError())
        let error = try? output.error.toBlocking(timeout: 1).first()

        // assert
        XCTAssert(useCase.getProductList_Called)
        XCTAssert(error is TestError)
    }

    func test_reloadTriggerInvoked_getProductList() {
        // act
        reloadTrigger.onNext(())
        let productSections = try? output.productSections.toBlocking(timeout: 1).first()

        // assert
        XCTAssert(useCase.getProductList_Called)
        XCTAssertEqual(productSections??[0].productList.count, 1)
    }

    func test_reloadTriggerInvoked_getProductList_failedShowError() {
        // arrange
        let getProductList_ReturnValue = PublishSubject<PagingInfo<Product>>()
        useCase.getProductList_ReturnValue = getProductList_ReturnValue

        // act
        reloadTrigger.onNext(())
        getProductList_ReturnValue.onError(TestError())
        let error = try? output.error.toBlocking(timeout: 1).first()

        // assert
        XCTAssert(useCase.getProductList_Called)
        XCTAssert(error is TestError)
    }

    func test_reloadTriggerInvoked_notGetProductListIfStillLoading() {
        // arrange
        let getProductList_ReturnValue = PublishSubject<PagingInfo<Product>>()
        useCase.getProductList_ReturnValue = getProductList_ReturnValue

        // act
        loadTrigger.onNext(())
        useCase.getProductList_Called = false
        reloadTrigger.onNext(())

        // assert
        XCTAssertFalse(useCase.getProductList_Called)
    }

    func test_reloadTriggerInvoked_notGetProductListIfStillReloading() {
        // arrange
        let getProductList_ReturnValue = PublishSubject<PagingInfo<Product>>()
        useCase.getProductList_ReturnValue = getProductList_ReturnValue

        // act
        reloadTrigger.onNext(())
        useCase.getProductList_Called = false
        reloadTrigger.onNext(())

        // assert
        XCTAssertFalse(useCase.getProductList_Called)
    }

    func test_loadMoreTriggerInvoked_loadMoreProductList() {
        // act
        loadTrigger.onNext(())
        loadMoreTrigger.onNext(())
        let productSections = try? output.productSections.toBlocking(timeout: 1).first()

        // assert
        XCTAssert(useCase.loadMoreProductList_Called)
        XCTAssertEqual(productSections??[0].productList.count, 2)
    }

    func test_loadMoreTriggerInvoked_loadMoreProductList_failedShowError() {
        // arrange
        let loadMoreProductList_ReturnValue = PublishSubject<PagingInfo<Product>>()
        useCase.loadMoreProductList_ReturnValue = loadMoreProductList_ReturnValue

        // act
        loadTrigger.onNext(())
        loadMoreTrigger.onNext(())
        loadMoreProductList_ReturnValue.onError(TestError())
        let error = try? output.error.toBlocking(timeout: 1).first()

        // assert
        XCTAssert(useCase.loadMoreProductList_Called)
        XCTAssert(error is TestError)
    }

    func test_loadMoreTriggerInvoked_notLoadMoreProductListIfStillLoading() {
        // arrange
        let getProductList_ReturnValue = PublishSubject<PagingInfo<Product>>()
        useCase.getProductList_ReturnValue = getProductList_ReturnValue

        // act
        loadTrigger.onNext(())
        useCase.getProductList_Called = false
        loadMoreTrigger.onNext(())

        // assert
        XCTAssertFalse(useCase.loadMoreProductList_Called)
    }

    func test_loadMoreTriggerInvoked_notLoadMoreProductListIfStillReloading() {
        // arrange
        let getProductList_ReturnValue = PublishSubject<PagingInfo<Product>>()
        useCase.getProductList_ReturnValue = getProductList_ReturnValue

        // act
        reloadTrigger.onNext(())
        useCase.getProductList_Called = false
        loadMoreTrigger.onNext(())
        // assert
        XCTAssertFalse(useCase.loadMoreProductList_Called)
    }

    func test_loadMoreTriggerInvoked_notLoadMoreDocumentTypesStillLoadingMore() {
        // arrange
        let loadMoreProductList_ReturnValue = PublishSubject<PagingInfo<Product>>()
        useCase.loadMoreProductList_ReturnValue = loadMoreProductList_ReturnValue

        // act
        loadMoreTrigger.onNext(())
        useCase.loadMoreProductList_Called = false
        loadMoreTrigger.onNext(())

        // assert
        XCTAssertFalse(useCase.loadMoreProductList_Called)
    }

    func test_selectProductTriggerInvoked_toProductDetail() {
        // act
        loadTrigger.onNext(())
        selectProductTrigger.onNext(IndexPath(row: 0, section: 0))

        // assert
        XCTAssert(navigator.toProductDetail_Called)
    }
}

