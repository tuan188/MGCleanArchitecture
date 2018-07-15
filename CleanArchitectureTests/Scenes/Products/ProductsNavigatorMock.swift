//
// ProductsNavigatorMock.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/5/18.
// Copyright © 2018 Framgia. All rights reserved.
//

@testable import CleanArchitecture

final class ProductsNavigatorMock: ProductsNavigatorType {
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
    
    // MARK: - confirmDeleteProduct
    var confirmDeleteProduct_Called = false
    var confirmDeleteProduct_ReturnValue: Driver<Void> = Driver.just(())
    func confirmDeleteProduct(_ product: Product) -> Driver<Void> {
        confirmDeleteProduct_Called = true
        return confirmDeleteProduct_ReturnValue
    }
}

