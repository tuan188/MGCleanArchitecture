//
//  TestError.swift
//  CleanArchitectureTests
//
//  Created by Tuan Truong on 6/5/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

import UIKit
import Validator

struct TestError: Error {

}

struct TestValidationError: ValidationError {
    var message: String {
        return "validation error"
    }
}
