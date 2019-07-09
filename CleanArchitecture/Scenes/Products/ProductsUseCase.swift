//
//  ProductsUseCase.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/5/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

protocol ProductsUseCaseType {
    func getProductList(page: Int) -> Observable<PagingInfo<Product>>
    func deleteProduct(id: Int) -> Observable<Void>
}

struct ProductsUseCase: ProductsUseCaseType {
    let productRepository: ProductRepositoryType
    
    func getProductList(page: Int) -> Observable<PagingInfo<Product>> {
        return productRepository.getProductList(page: page)
    }
    
    func deleteProduct(id: Int) -> Observable<Void> {
        return Observable.just(())
    }
}

