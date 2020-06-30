//
//  ValidatingProductPrice.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/29/20.
//  Copyright © 2020 Sun Asterisk. All rights reserved.
//

import UIKit

protocol ValidatingProductPrice {
    
}

extension ValidatingProductPrice {
    func validateProductPrice(_ price: String) -> ValidationResult {
        let priceNumber = Double(price) ?? 0.0
        
        if priceNumber <= 0 {
            return ValidationResult.invalid([ProductValidationError.productPriceMinValue])
        }
        
        return ValidationResult.valid
    }
}
