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
    var toProductDetail_Called = false
    func toProductDetail(product: Product) {
        toProductDetail_Called = true
    }
    
    // MARK: - toEditProduct
    var toEditProduct_Called = false
    func toEditProduct(_ product: Product) {
        toEditProduct_Called = true
    }
}

