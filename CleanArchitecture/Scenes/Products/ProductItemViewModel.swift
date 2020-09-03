//
//  ProductItemViewModel.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 9/6/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

struct ProductItemViewModel {
    let name: String
    let price: String
    let icon: UIImage?
    let backgroundColor: UIColor
    
    init(product: ProductModel) {
        self.name = product.product.name
        self.price = product.product.price.currency
        self.icon = product.edited ? #imageLiteral(resourceName: "edited") : nil
        self.backgroundColor = product.edited
            ? UIColor.yellow.withAlphaComponent(0.2)
            : ColorCompatibility.systemBackground
    }
}
