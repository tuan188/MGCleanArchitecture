//
//  ValidatedProperty.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 8/27/20.
//  Copyright © 2020 Sun Asterisk. All rights reserved.
//

import ValidatedPropertyKit

public protocol ValidatedProperty {
    var isValid: Bool { get }
    var validationError: ValidationError? { get }
}

extension Validated: ValidatedProperty { }
