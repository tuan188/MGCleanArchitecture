//
// SectionedProductsNavigatorMock.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/7/18.
// Copyright © 2018 Framgia. All rights reserved.
//

@testable import CleanArchitecture

final class SectionedProductsNavigatorMock: SectionedProductsNavigatorType {
    
    // MARK: - toProductDetail
    
    var toProductDetailCalled = false
    
    func toProductDetail(product: Product) {
        toProductDetailCalled = true
    }
    
    // MARK: - toEditProduct
    
    var toEditProductCalled = false
    
    func toEditProduct(_ product: Product) {
        toEditProductCalled = true
    }
}

