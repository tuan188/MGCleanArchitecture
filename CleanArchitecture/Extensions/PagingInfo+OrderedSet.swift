//
//  PagingInfo+OrderedSet.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 4/8/19.
//  Copyright © 2019 Framgia. All rights reserved.
//

import Foundation

extension PagingInfo where T: Hashable {
    public var itemSet: OrderedSet<T> {
        return OrderedSet(sequence: items)
    }
}
