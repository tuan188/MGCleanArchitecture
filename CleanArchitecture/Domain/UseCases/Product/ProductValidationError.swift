//
//  ProductValidationError.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/29/20.
//  Copyright © 2020 Sun Asterisk. All rights reserved.
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
