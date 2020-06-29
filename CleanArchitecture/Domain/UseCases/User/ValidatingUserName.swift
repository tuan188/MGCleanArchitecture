//
//  ValidatingUserName.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/26/20.
//  Copyright © 2020 Sun Asterisk. All rights reserved.
//

import UIKit

protocol ValidatingUserName {

}

extension ValidatingUserName {
    func validateUserName(_ username: String) -> ValidationResult {
        let minLengthRule = ValidationRuleLength(min: 1, error: UserValidationError.usernameMinLength)
        return username.validate(rule: minLengthRule)
    }
}
