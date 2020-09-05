//
//  Validation+Comparable.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 8/26/20.
//  Copyright © 2020 Sun Asterisk. All rights reserved.
//

import ValidatedPropertyKit

extension Validation where Value: Comparable {
    
    public static func greaterOrEqual(_ comparableValue: Value, message: String) -> Validation {
        return .init { value in
            if value >= comparableValue {
                return .success(())
            } else {
                return .failure(ValidationError(message: message))
            }
        }
    }
    
    public static func greater(_ comparableValue: Value, message: String) -> Validation {
        return .init { value in
            if value > comparableValue {
                return .success(())
            } else {
                return .failure(ValidationError(message: message))
            }
        }
    }
    
}
