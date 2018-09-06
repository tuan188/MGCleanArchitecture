//
//  ProductViewModel.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 9/6/18.
//  Copyright © 2018 Framgia. All rights reserved.
//

struct ProductViewModel {
    let product: ProductModel
    
    var name: String {
        return product.product.name
    }
    
    var price: String {
        return product.product.price.currency
    }
}
