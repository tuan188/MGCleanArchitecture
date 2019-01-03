//
//  Optional+.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 1/3/19.
//  Copyright © 2019 Framgia. All rights reserved.
//

extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}

extension Optional {
    func orThrow( _ errorExpression: @autoclosure () -> Error) throws -> Wrapped {
        guard let value = self else {
            throw errorExpression()
        }
        return value
    }
}
