//
//  ValidatingProductName.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/29/20.
//  Copyright © 2020 Sun Asterisk. All rights reserved.
//

import UIKit

protocol ValidatingProductName {
    
}

extension ValidatingProductName {
    func validateProductName(_ name: String) -> ValidationResult {
        let minLengthRule = ValidationRuleLength(min: 5, error: ProductValidationError.productNameMinLength)
        return name.validate(rule: minLengthRule)
    }
}
