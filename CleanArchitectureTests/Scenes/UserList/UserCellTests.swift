//
//  UserCellTests.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 1/14/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

@testable import CleanArchitecture
import XCTest

final class UserCellTests: XCTestCase {
    var cell: UserCell!

    override func setUp() {
        super.setUp()
        cell = UserCell.loadFromNib()
    }

    func test_ibOutlets() {
        XCTAssertNotNil(cell)
        XCTAssertNotNil(cell.nameLabel)
        XCTAssertNotNil(cell.genderLabel)
        XCTAssertNotNil(cell.birthdayLabel)
    }
}
