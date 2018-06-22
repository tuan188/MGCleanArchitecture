//
// StaticProductDetailViewControllerTests.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/24/18.
// Copyright © 2018 Framgia. All rights reserved.
//

@testable import CleanArchitecture
import XCTest
import Reusable

final class StaticProductDetailViewControllerTests: XCTestCase {

    private var viewController: StaticProductDetailViewController!

    override func setUp() {
        super.setUp()
        viewController = StaticProductDetailViewController.instantiate()
    }

    func test_ibOutlets() {
        _ = viewController.view
        XCTAssertNotNil(viewController.tableView)
        XCTAssertNotNil(viewController.nameLabel)
        XCTAssertNotNil(viewController.priceLabel)
    }
}
