//
//  ValidationError.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/28/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

import UIKit

enum ValidationError: Error {
    case productNameMinLength
    case productPriceMinValue
    case usernameMinLength
    case passwordMinLength
}

extension ValidationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .productNameMinLength:
            return "Product name must be at least 5 characters."
        case .productPriceMinValue:
            return "Product price must be greater than 0."
        case .usernameMinLength:
            return "Please enter your username."
        case .passwordMinLength:
            return "Please enter your password"
        }
    }
}
