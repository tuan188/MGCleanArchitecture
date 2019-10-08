//
//  ValidationError.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/28/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

import UIKit

enum ProductValidationError: ValidationError {
    case productNameMinLength
    case productPriceMinValue
    
    var message: String {
        switch self {
        case .productNameMinLength:
            return "Product name must be at least 5 characters."
        case .productPriceMinValue:
            return "Product price must be greater than 0."
        }
    }
}

enum LoginValidationError: ValidationError {
    case usernameMinLength
    case passwordMinLength
    
    var message: String {
        switch self {
        case .usernameMinLength:
            return "Please enter your username."
        case .passwordMinLength:
            return "Please enter your password"
        }
    }
}
