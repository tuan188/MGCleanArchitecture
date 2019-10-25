//
//  ProductViewModelTests.swift
//  CleanArchitectureTests
//
//  Created by Tuan Truong on 11/6/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

import XCTest
@testable import CleanArchitecture

final class ProductViewModelTests: XCTestCase {
    
    let product = Product().with {
        $0.name = "Foo"
        $0.price = 1.0
    }

    func test_product() {
        let model = ProductModel(product: product, edited: false)
        let viewModel = ProductViewModel(product: model)
        XCTAssertEqual(viewModel.name, product.name)
        XCTAssertEqual(viewModel.price, product.price.currency)
        XCTAssertNil(viewModel.icon)
    }
    
    func test_edited_product() {
        let model = ProductModel(product: product, edited: true)
        let viewModel = ProductViewModel(product: model)
        XCTAssertEqual(viewModel.name, product.name)
        XCTAssertEqual(viewModel.price, product.price.currency)
        XCTAssertNotNil(viewModel.icon)
    }

}
