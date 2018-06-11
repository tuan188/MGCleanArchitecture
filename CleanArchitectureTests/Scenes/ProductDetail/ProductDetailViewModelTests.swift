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

    override func setUp() {
        super.setUp()
        navigator = ProductDetailNavigatorMock()
        useCase = ProductDetailUseCaseMock()
        viewModel = ProductDetailViewModel(navigator: navigator,
                                           useCase: useCase,
                                           product: Product())
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

        // assert
        XCTAssertNotEqual(cells??.count, 0)
    }

}
