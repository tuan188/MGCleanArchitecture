//
//  StaticProductDetailViewModelTests.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/24/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

@testable import CleanArchitecture
import XCTest
import RxSwift
import RxBlocking

final class StaticProductDetailViewModelTests: XCTestCase {

    private var viewModel: StaticProductDetailViewModel!
    private var navigator: StaticProductDetailNavigatorMock!
    private var useCase: StaticProductDetailUseCaseMock!
    
    private var input: StaticProductDetailViewModel.Input!
    private var output: StaticProductDetailViewModel.Output!
    
    private var disposeBag: DisposeBag!
    
    private let loadTrigger = PublishSubject<Void>()
    private let product = Product(id: 1, name: "Foo", price: 1)

    override func setUp() {
        super.setUp()
        navigator = StaticProductDetailNavigatorMock()
        useCase = StaticProductDetailUseCaseMock()
        viewModel = StaticProductDetailViewModel(navigator: navigator, useCase: useCase, product: product)
        
        input = StaticProductDetailViewModel.Input(
            loadTrigger: loadTrigger.asDriverOnErrorJustComplete()
        )
        
        disposeBag = DisposeBag()
        output = viewModel.transform(input, disposeBag: disposeBag)
    }

    func test_loadTriggerInvoked_createCells() {
        // act
        loadTrigger.onNext(())

        // assert
        XCTAssertEqual(output.name, product.name)
        XCTAssertEqual(output.price, product.price.currency)
    }

}
