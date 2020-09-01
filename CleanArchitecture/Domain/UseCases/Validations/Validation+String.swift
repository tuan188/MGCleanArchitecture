//
//  Validation+String.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 8/26/20.
//  Copyright © 2020 Sun Asterisk. All rights reserved.
//

import ValidatedPropertyKit

public extension Validation where Value == String {
    static func matches(_ pattern: String,
                        options: NSRegularExpression.Options = .init(),
                        matchingOptions: NSRegularExpression.MatchingOptions = .init(),
                        message: String) -> Validation {
        guard let regularExpression = try? NSRegularExpression(pattern: pattern, options: options) else {
            return .init { _ in .failure("Invalid regular expression: \(pattern)") }
        }
        
        return self.matches(
            regularExpression,
            matchingOptions: matchingOptions,
            message: message
        )
    }
    
    static func matches(_ regex: NSRegularExpression,
                        matchingOptions: NSRegularExpression.MatchingOptions = .init(),
                        message: String) -> Validation {
        return .init { value in
            let firstMatchIsAvailable = regex.firstMatch(
                in: value,
                options: matchingOptions,
                range: .init(value.startIndex..., in: value)
                ) != nil
            
            if firstMatchIsAvailable {
                return .success(())
            } else {
                return .failure(ValidationError(message: message))
            }
        }
    }
    
    static func isNumber(message: String) -> Validation {
        return self.matches(#"[+-]?\d+(\.\d+)?([Ee][+-]?\d+)?"#, message: message)
    }
}

