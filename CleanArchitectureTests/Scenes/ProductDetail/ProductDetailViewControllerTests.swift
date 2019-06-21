//
//  ProductDetailViewControllerTests.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/22/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

@testable import CleanArchitecture
import XCTest
import Reusable

final class ProductDetailViewControllerTests: XCTestCase {

    var viewController: ProductDetailViewController!

    override func setUp() {
        super.setUp()
        viewController = ProductDetailViewController.instantiate()
    }

    func test_ibOutlets() {
        _ = viewController.view
        XCTAssertNotNil(viewController.tableView)
    }
}
