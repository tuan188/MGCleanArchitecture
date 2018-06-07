//
//  Product.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/5/18.
//  Copyright © 2018 Framgia. All rights reserved.
//

struct Product {
    var id: Int
    var name: String
    var price: Double
}

extension Product {
    init() {
        self.init(id: 0, name: "", price: 0.0)
    }
}

extension Product: Then, HasID, Hashable { }
