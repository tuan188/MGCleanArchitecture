//
// ProductsViewControllerTests.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/5/18.
// Copyright © 2018 Framgia. All rights reserved.
//

@testable import CleanArchitecture
import XCTest
import Reusable

final class ProductsViewControllerTests: XCTestCase {

    private var viewController: ProductsViewController!

    override func setUp() {
		super.setUp()
        viewController = ProductsViewController.instantiate()
	}

    func test_ibOutlets() {
        _ = viewController.view
        XCTAssertNotNil(viewController.tableView)
    }
}
