//
//  RepoTests.swift
//  CleanArchitectureTests
//
//  Created by Tuan Truong on 11/6/18.
//  Copyright © 2018 Framgia. All rights reserved.
//

import XCTest
@testable import CleanArchitecture

final class RepoTests: XCTestCase {

    func test_mapping() {
        let json: [String: Any] = [
            "id": 1,
            "name": "foo",
            "full_name": "bar"
        ]
        let repo = Repo(JSON: json)
        
        XCTAssertNotNil(repo)
        XCTAssertEqual(repo?.id, json["id"] as? Int)
        XCTAssertEqual(repo?.name, json["name"] as? String)
        XCTAssertEqual(repo?.fullname, json["full_name"] as? String)
    }

}
