//
//  ViewModelType+.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 1/3/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

import Validator

extension ViewModelType {
    func validate<T>(object: Driver<T>,
                     trigger: Driver<Void>,
                     validator: @escaping (T) -> ValidationResult) -> Driver<ValidationResult> {
        return Driver.combineLatest(object, trigger)
            .map { $0.0 }
            .map { validator($0) }
            .startWith(.valid)
    }
}
