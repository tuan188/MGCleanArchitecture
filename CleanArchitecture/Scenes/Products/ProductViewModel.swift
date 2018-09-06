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
    
    var icon: UIImage? {
        return product.edited ? #imageLiteral(resourceName: "edited") : nil
    }
    
    var backgroundColor: UIColor {
        return product.edited ? UIColor.yellow.withAlphaComponent(0.5) : UIColor.white
    }
}
