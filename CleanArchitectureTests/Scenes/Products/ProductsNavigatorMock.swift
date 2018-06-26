//
// ProductsNavigatorMock.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/5/18.
// Copyright © 2018 Framgia. All rights reserved.
//

@testable import CleanArchitecture

final class ProductsNavigatorMock: ProductsNavigatorType {
    
    // MARK: - toProducts
    var toProducts_Called = false
    func toProducts() {
        toProducts_Called = true
    }
    
    // MARK: - toProductDetail
    var toProductDetail_Called = false
    func toProductDetail(product: Product) {
        toProductDetail_Called = true
    }
    
    // MARK: - toEditProduct
    var toEditProduct_Called = false
    var toEditProduct_ReturnValue = Driver<EditProductDelegate>.empty()
    func toEditProduct(_ product: Product) -> Driver<EditProductDelegate> {
        toEditProduct_Called = true
        return toEditProduct_ReturnValue
    }
    
}

