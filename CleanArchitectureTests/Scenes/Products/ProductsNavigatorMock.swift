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
    
    var toProductDetailCalled = false
    
    func toProductDetail(product: Product) {
        toProductDetailCalled = true
    }
    
    // MARK: - toEditProduct
    
    var toEditProductCalled = false
    var toEditProductReturnValue = Driver<EditProductDelegate>.empty()
    
    func toEditProduct(_ product: Product) -> Driver<EditProductDelegate> {
        toEditProductCalled = true
        return toEditProductReturnValue
    }
    
    // MARK: - confirmDeleteProduct
    
    var confirmDeleteProductCalled = false
    var confirmDeleteProductReturnValue: Driver<Void> = Driver.just(())
    
    func confirmDeleteProduct(_ product: Product) -> Driver<Void> {
        confirmDeleteProductCalled = true
        return confirmDeleteProductReturnValue
    }
}

