//
// EditProductViewControllerTests.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/24/18.
// Copyright © 2018 Framgia. All rights reserved.
//

@testable import CleanArchitecture
import XCTest
import Reusable

final class EditProductViewControllerTests: XCTestCase {

    var viewController: EditProductViewController!

    override func setUp() {
        super.setUp()
        viewController = EditProductViewController.instantiate()
    }

    func test_ibOutlets() {
        _ = viewController.view
        XCTAssertNotNil(viewController.tableView)
    }
}
