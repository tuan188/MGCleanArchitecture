//
//  MainViewControllerTests.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/4/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

@testable import CleanArchitecture
import XCTest
import Reusable

final class MainViewControllerTests: XCTestCase {

    var viewController: MainViewController!

    override func setUp() {
        super.setUp()
        viewController = MainViewController.instantiate()
    }

    func test_ibOutlets() {
        _ = viewController.view
        XCTAssertNotNil(viewController.tableView)
    }
}
