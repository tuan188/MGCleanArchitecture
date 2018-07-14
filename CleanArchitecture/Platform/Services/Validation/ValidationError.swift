//
//  ValidationError.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/28/18.
//  Copyright © 2018 Framgia. All rights reserved.
//

import UIKit

enum ValidationError: Error {
    case productNameMinLength
    case productPriceMinValue
}

extension ValidationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .productNameMinLength:
            return "Product name must be at least 5 characters."
        case .productPriceMinValue:
            return "Product price must be greater than 0."
        }
    }
}
