//
//  ServiceHelper.swift
//  CleanArchitectureTests
//
//  Created by Anh Nguyen on 6/04/19.
//  Copyright © 2019 Framgia. All rights reserved.
//

import XCTest

extension XCTestCase {
    func loadStub(name: String, extension: String) -> Data {
        let bundle = Bundle(for: classForCoder)
        let url = bundle.url(forResource: name, withExtension: `extension`)
        
        return try! Data(contentsOf: url!)
    }
}
