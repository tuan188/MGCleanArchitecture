//
// ProductCellTests.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/5/18.
// Copyright © 2018 Framgia. All rights reserved.
//

import XCTest
@testable import CleanArchitecture

final class ProductCellTests: XCTestCase {
    var cell: ProductCell!

    override func setUp() {
        super.setUp()
        cell = ProductCell.loadFromNib()
    }

    func test_iboutlets() {
        XCTAssertNotNil(cell)
        XCTAssertNotNil(cell.nameLabel)
        XCTAssertNotNil(cell.priceLabel)
        XCTAssertNotNil(cell.editButton)
    }
}
