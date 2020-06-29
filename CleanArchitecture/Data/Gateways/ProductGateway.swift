//
//  ProductGateway.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/26/20.
//  Copyright © 2020 Sun Asterisk. All rights reserved.
//

import UIKit

protocol ProductGatewayType {
    func getProductList(page: Int) -> Observable<PagingInfo<Product>>
    func deleteProduct(id: Int) -> Observable<Void>
    func update(_ product: Product) -> Observable<Void>
}

struct ProductGateway: ProductGatewayType {
    let productRepository = ProductRepository()
    
    func getProductList(page: Int) -> Observable<PagingInfo<Product>> {
        return productRepository.getProductList(page: page)
    }
    
    func deleteProduct(id: Int) -> Observable<Void> {
        return productRepository.deleteProduct(id: id)
    }
    
    func update(_ product: Product) -> Observable<Void> {
        return productRepository.update(product)
    }
}
