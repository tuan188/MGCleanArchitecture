//
// SectionedProductsViewControllerTests.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/7/18.
// Copyright © 2018 Framgia. All rights reserved.
//

@testable import CleanArchitecture
import XCTest
import Reusable

final class SectionedProductsViewControllerTests: XCTestCase {

    private var viewController: SectionedProductsViewController!

    override func setUp() {
		super.setUp()
        viewController = SectionedProductsViewController.instantiate()
	}

    func test_ibOutlets() {
        _ = viewController.view
        XCTAssertNotNil(viewController.tableView)
    }
}
