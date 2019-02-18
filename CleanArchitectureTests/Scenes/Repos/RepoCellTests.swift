//
// RepoCellTests.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/28/18.
// Copyright © 2018 Framgia. All rights reserved.
//

import XCTest
@testable import CleanArchitecture

final class RepoCellTests: XCTestCase {
    var cell: RepoCell!

    override func setUp() {
        super.setUp()
        cell = RepoCell.loadFromNib()
    }

    func test_ibOutlets() {
        XCTAssertNotNil(cell)
        XCTAssertNotNil(cell.nameLabel)
        XCTAssertNotNil(cell.avatarURLStringImageView)
    }
}
