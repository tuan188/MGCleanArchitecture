//
//  MenuCellTests.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/4/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

import XCTest
@testable import CleanArchitecture

final class MenuCellTests: XCTestCase {
    var cell: MenuCell!

    override func setUp() {
        super.setUp()
        cell = MenuCell.loadFromNib()
    }

    func test_ibOutlets() {
        XCTAssertNotNil(cell)
        XCTAssertNotNil(cell.titleLabel)
    }
}
