//
// ProductsViewModelTests.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/5/18.
// Copyright © 2018 Framgia. All rights reserved.
//

@testable import CleanArchitecture
import XCTest
import RxSwift
import RxBlocking

final class ProductsViewModelTests: XCTestCase {
    private var viewModel: ProductsViewModel!
    private var navigator: ProductsNavigatorMock!
    private var useCase: ProductsUseCaseMock!
    
    private var input: ProductsViewModel.Input!
    private var output: ProductsViewModel.Output!
    
    private var disposeBag: DisposeBag!
    
    private let loadTrigger = PublishSubject<Void>()
    private let reloadTrigger = PublishSubject<Void>()
    private let loadMoreTrigger = PublishSubject<Void>()
    private let selectProductTrigger = PublishSubject<IndexPath>()
    private let editProductTrigger = PublishSubject<IndexPath>()
    private let deleteProductTrigger = PublishSubject<IndexPath>()

    override func setUp() {
        super.setUp()
        navigator = ProductsNavigatorMock()
        useCase = ProductsUseCaseMock()
        viewModel = ProductsViewModel(navigator: navigator, useCase: useCase)
        disposeBag = DisposeBag()
        input = ProductsViewModel.Input(
            loadTrigger: loadTrigger.asDriverOnErrorJustComplete(),
            reloadTrigger: reloadTrigger.asDriverOnErrorJustComplete(),
            loadMoreTrigger: loadMoreTrigger.asDriverOnErrorJustComplete(),
            selectProductTrigger: selectProductTrigger.asDriverOnErrorJustComplete(),
            editProductTrigger: editProductTrigger.asDriverOnErrorJustComplete(),
            deleteProductTrigger: deleteProductTrigger.asDriverOnErrorJustComplete()
        )
        output = viewModel.transform(input)
        output.error.drive().disposed(by: disposeBag)
        output.loading.drive().disposed(by: disposeBag)
        output.refreshing.drive().disposed(by: disposeBag)
        output.loadingMore.drive().disposed(by: disposeBag)
        output.fetchItems.drive().disposed(by: disposeBag)
        output.productList.drive().disposed(by: disposeBag)
        output.selectedProduct.drive().disposed(by: disposeBag)
        output.isEmptyData.drive().disposed(by: disposeBag)
        output.editedProduct.drive().disposed(by: disposeBag)
        output.deletedProduct.drive().disposed(by: disposeBag)
    }

    func test_loadTriggerInvoked_getProductList() {
        // act
        loadTrigger.onNext(())
        let productList = try? output.productList.toBlocking(timeout: 1).first()
        
        // assert
        XCTAssert(useCase.getProductListCalled)
        XCTAssertEqual(productList??.count, 1)
    }

    func test_loadTriggerInvoked_getProductList_failedShowError() {
        // arrange
        let getProductListReturnValue = PublishSubject<PagingInfo<Product>>()
        useCase.getProductListReturnValue = getProductListReturnValue

        // act
        loadTrigger.onNext(())
        getProductListReturnValue.onError(TestError())
        let error = try? output.error.toBlocking(timeout: 1).first()

        // assert
        XCTAssert(useCase.getProductListCalled)
        XCTAssert(error is TestError)
    }

    func test_reloadTriggerInvoked_getProductList() {
        // act
        reloadTrigger.onNext(())
        let productList = try? output.productList.toBlocking(timeout: 1).first()

        // assert
        XCTAssert(useCase.getProductListCalled)
        XCTAssertEqual(productList??.count, 1)
    }

    func test_reloadTriggerInvoked_getProductList_failedShowError() {
        // arrange
        let getProductListReturnValue = PublishSubject<PagingInfo<Product>>()
        useCase.getProductListReturnValue = getProductListReturnValue

        // act
        reloadTrigger.onNext(())
        getProductListReturnValue.onError(TestError())
        let error = try? output.error.toBlocking(timeout: 1).first()

        // assert
        XCTAssert(useCase.getProductListCalled)
        XCTAssert(error is TestError)
    }

    func test_reloadTriggerInvoked_notGetProductListIfStillLoading() {
        // arrange
        let getProductListReturnValue = PublishSubject<PagingInfo<Product>>()
        useCase.getProductListReturnValue = getProductListReturnValue

        // act
        loadTrigger.onNext(())
        useCase.getProductListCalled = false
        reloadTrigger.onNext(())

        // assert
        XCTAssertFalse(useCase.getProductListCalled)
    }

    func test_reloadTriggerInvoked_notGetProductListIfStillReloading() {
        // arrange
        let getProductListReturnValue = PublishSubject<PagingInfo<Product>>()
        useCase.getProductListReturnValue = getProductListReturnValue

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
        let productList = try? output.productList.toBlocking(timeout: 1).first()

        // assert
        XCTAssert(useCase.loadMoreProductListCalled)
        XCTAssertEqual(productList??.count, 2)
    }

    func test_loadMoreTriggerInvoked_loadMoreProductList_failedShowError() {
        // arrange
        let loadMoreProductListReturnValue = PublishSubject<PagingInfo<Product>>()
        useCase.loadMoreProductListReturnValue = loadMoreProductListReturnValue

        // act
        loadTrigger.onNext(())
        loadMoreTrigger.onNext(())
        loadMoreProductListReturnValue.onError(TestError())
        let error = try? output.error.toBlocking(timeout: 1).first()

        // assert
        XCTAssert(useCase.loadMoreProductListCalled)
        XCTAssert(error is TestError)
    }

    func test_loadMoreTriggerInvoked_notLoadMoreProductListIfStillLoading() {
        // arrange
        let getProductListReturnValue = PublishSubject<PagingInfo<Product>>()
        useCase.getProductListReturnValue = getProductListReturnValue

        // act
        loadTrigger.onNext(())
        useCase.getProductListCalled = false
        loadMoreTrigger.onNext(())

        // assert
        XCTAssertFalse(useCase.loadMoreProductListCalled)
    }

    func test_loadMoreTriggerInvoked_notLoadMoreProductListIfStillReloading() {
        // arrange
        let getProductListReturnValue = PublishSubject<PagingInfo<Product>>()
        useCase.getProductListReturnValue = getProductListReturnValue

        // act
        reloadTrigger.onNext(())
        useCase.getProductListCalled = false
        loadMoreTrigger.onNext(())
        // assert
        XCTAssertFalse(useCase.loadMoreProductListCalled)
    }

    func test_loadMoreTriggerInvoked_notLoadMoreDocumentTypesStillLoadingMore() {
        // arrange
        let loadMoreProductListReturnValue = PublishSubject<PagingInfo<Product>>()
        useCase.loadMoreProductListReturnValue = loadMoreProductListReturnValue

        // act
        loadMoreTrigger.onNext(())
        useCase.loadMoreProductListCalled = false
        loadMoreTrigger.onNext(())

        // assert
        XCTAssertFalse(useCase.loadMoreProductListCalled)
    }

    func test_selectProductTriggerInvoked_toProductDetail() {
        // act
        loadTrigger.onNext(())
        selectProductTrigger.onNext(IndexPath(row: 0, section: 0))

        // assert
        XCTAssert(navigator.toProductDetailCalled)
    }
    
    func test_editProductTriggerInvoked_editProduct() {
        // act
        loadTrigger.onNext(())
        editProductTrigger.onNext(IndexPath(row: 0, section: 0))

        // assert
        XCTAssert(navigator.toEditProductCalled)
    }
    
    func test_deletedProductInvoked_deleteProduct() {
        // act
        loadTrigger.onNext(())
        deleteProductTrigger.onNext(IndexPath(row: 0, section: 0))

        // assert
        XCTAssert(navigator.confirmDeleteProductCalled)
        XCTAssert(useCase.deleteProductCalled)
    }
    
}

