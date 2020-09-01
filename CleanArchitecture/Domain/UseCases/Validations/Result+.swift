//
//  Result+.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 8/27/20.
//  Copyright © 2020 Sun Asterisk. All rights reserved.
//

import ValidatedPropertyKit

typealias ValidationResult = Result<Void, ValidationError>

extension Result where Failure == ValidationError {
    
    /// Failure message
    var message: String {
        switch self {
        case .success:
            return ""
        case .failure(let error):
            return error.description
        }
    }
    
    var isValid: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    func mapToVoid() -> ValidationResult {
        return self.map { _ in () }
    }
}
