//
//  ValidatingPassword.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/26/20.
//  Copyright © 2020 Sun Asterisk. All rights reserved.
//

import UIKit

protocol ValidatingPassword {

}

extension ValidatingPassword {
    func validatePassword(_ password: String) -> ValidationResult {
        let minLengthRule = ValidationRuleLength(min: 1, error: UserValidationError.passwordMinLength)
        return password.validate(rule: minLengthRule)
    }
}
