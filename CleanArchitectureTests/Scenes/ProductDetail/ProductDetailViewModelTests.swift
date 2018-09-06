//
// ProductDetailViewModelTests.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/22/18.
// Copyright © 2018 Framgia. All rights reserved.
//

@testable import CleanArchitecture
import XCTest
import RxSwift
import RxBlocking

final class ProductDetailViewModelTests: XCTestCase {

    private var viewModel: ProductDetailViewModel!
    private var navigator: ProductDetailNavigatorMock!
    private var useCase: ProductDetailUseCaseMock!
    private var disposeBag: DisposeBag!
    private var input: ProductDetailViewModel.Input!
    private var output: ProductDetailViewModel.Output!
    private let loadTrigger = PublishSubject<Void>()
    private let product = Product(id: 1, name: "Foo", price: 1)

    override func setUp() {
        super.setUp()
        navigator = ProductDetailNavigatorMock()
        useCase = ProductDetailUseCaseMock()
        viewModel = ProductDetailViewModel(navigator: navigator, useCase: useCase, product: product)
        disposeBag = DisposeBag()
        input = ProductDetailViewModel.Input(
            loadTrigger: loadTrigger.asDriverOnErrorJustComplete()
        )
        output = viewModel.transform(input)
        output.cells.drive().disposed(by: disposeBag)
    }

    func test_loadTriggerInvoked_createCells() {
        // act
        loadTrigger.onNext(())
        let cells = try? output.cells.toBlocking(timeout: 1).first()
        var productName: String? = nil
        var productPrice: String? = nil
        if let nameCellType = cells??[0],
            case let ProductDetailViewModel.CellType.name(name) = nameCellType {
            productName = name
        }
        if let priceCellType = cells??[1],
            case let ProductDetailViewModel.CellType.price(price) = priceCellType {
            productPrice = price
        }

        // assert
        XCTAssertEqual(cells??.count, 2)
        XCTAssertEqual(productName, product.name)
        XCTAssertEqual(productPrice, product.price.currency)
    }

}
