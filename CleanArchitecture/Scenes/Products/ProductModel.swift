//
//  ProductModel.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 9/6/18.
//  Copyright © 2018 Framgia. All rights reserved.
//

struct ProductModel {
    let product: Product
    let edited: Bool
}

extension ProductModel: Hashable {
    var hashValue: Int {
        return product.id
    }
    
    static func == (lhs: ProductModel, rhs: ProductModel) -> Bool {
        return lhs.product.id == rhs.product.id
    }
}

extension ProductModel {
    init(product: Product) {
        self.init(product: product, edited: false)
    }
}
