//
// ProductDetailCellsTests.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/22/18.
// Copyright © 2018 Framgia. All rights reserved.
//

@testable import CleanArchitecture
import XCTest

final class ProductDetailCellsTests: XCTestCase {

    private var nameCell: ProductNameCell!
    private var priceCell: ProductPriceCell!

    override func setUp() {
        super.setUp()
        nameCell = ProductNameCell.loadFromNib()
        priceCell = ProductPriceCell.loadFromNib()
    }

    func test_ibOutlets() {
        XCTAssertNotNil(nameCell.nameLabel)
        XCTAssertNotNil(priceCell.priceLabel)
    }
}
