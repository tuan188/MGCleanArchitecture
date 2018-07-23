//
// SectionedProductsUseCase.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/7/18.
// Copyright © 2018 Framgia. All rights reserved.
//

protocol SectionedProductsUseCaseType {
    func getProductList() -> Observable<PagingInfo<Product>>
    func loadMoreProductList(page: Int) -> Observable<PagingInfo<Product>>
}

struct SectionedProductsUseCase: SectionedProductsUseCaseType {
    let productRepository: ProductRepositoryType
    
    func getProductList() -> Observable<PagingInfo<Product>> {
        return loadMoreProductList(page: 1)
    }

    func loadMoreProductList(page: Int) -> Observable<PagingInfo<Product>> {
        return productRepository.getProductList(page: page)
    }
}

