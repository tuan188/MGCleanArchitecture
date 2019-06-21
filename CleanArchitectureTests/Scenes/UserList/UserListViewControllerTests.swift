//
//  UserListViewControllerTests.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 1/14/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

@testable import CleanArchitecture
import XCTest
import Reusable

final class UserListViewControllerTests: XCTestCase {
    private var viewController: UserListViewController!

    override func setUp() {
		super.setUp()
        viewController = UserListViewController.instantiate()
	}

    func test_ibOutlets() {
        _ = viewController.view
        XCTAssertNotNil(viewController.tableView)
    }
}
