//
//  UserValidationError.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/29/20.
//  Copyright © 2020 Sun Asterisk. All rights reserved.
//

import UIKit

enum UserValidationError: ValidationError {
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
