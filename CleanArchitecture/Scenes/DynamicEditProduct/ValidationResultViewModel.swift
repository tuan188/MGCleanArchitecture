//
//  ValidationResultViewModel.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 9/11/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

import UIKit

struct ValidationResultViewModel {
    let validationResult: ValidationResult
    
    var backgroundColor: UIColor {
        switch validationResult {
        case .valid:
            return UIColor.white
        case .invalid:
            return UIColor.yellow
        }
    }
    
    var text: String {
        switch validationResult {
        case .valid:
            return " "
        case .invalid(let errors):
            return errors.map { $0.message }.joined(separator: "\n")
        }
    }
}
