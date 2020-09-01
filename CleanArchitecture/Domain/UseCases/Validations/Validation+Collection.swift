//
//  Validation+Collection.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 8/31/20.
//  Copyright © 2020 Sun Asterisk. All rights reserved.
//

import ValidatedPropertyKit

public extension Validation where Value: Collection {
    
    static func nonEmpty(message: String) -> Validation {
        return .init { value in
            if !value.isEmpty {
                return .success(())
            } else {
                return .failure(ValidationError(message: message))
            }
        }
    }
    
    static func minLength(min: Int, message: String) -> Validation {
        return .init { value in
            if value.count >= min {
                return .success(())
            } else {
                return .failure(ValidationError(message: message))
            }
        }
    }
    
    static func maxLength(max: Int, message: String) -> Validation {
        return .init { value in
            if value.count <= max {
                return .success(())
            } else {
                return .failure(ValidationError(message: message))
            }
        }
    }
}
