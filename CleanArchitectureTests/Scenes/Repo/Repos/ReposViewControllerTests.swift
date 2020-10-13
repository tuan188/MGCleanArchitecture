//
//  ReposViewControllerTests.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/28/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

@testable import CleanArchitecture
import XCTest
import Reusable

final class ReposViewControllerTests: XCTestCase {

    private var viewController: ReposViewController!

    override func setUp() {
		super.setUp()
        viewController = ReposViewController.instantiate()
	}

    func test_ibOutlets() {
        _ = viewController.view
        XCTAssertNotNil(viewController.tableView)
    }
}
