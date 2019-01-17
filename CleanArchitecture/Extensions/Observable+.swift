//
//  Observable+.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 1/17/19.
//  Copyright © 2019 Framgia. All rights reserved.
//

import RxSwift

extension SharedSequenceConvertibleType where E == Bool {
    public func not() -> SharedSequence<SharingStrategy, Bool> {
        return self.map(!)
    }
}
