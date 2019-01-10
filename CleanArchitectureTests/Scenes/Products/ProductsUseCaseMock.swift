//
// ProductsUseCaseMock.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/5/18.
// Copyright © 2018 Framgia. All rights reserved.
//

@testable import CleanArchitecture
import RxSwift

final class ProductsUseCaseMock: ProductsUseCaseType {

    // MARK: - getProductList
    
    var getProductListCalled = false
    
    var getProductListReturnValue: Observable<PagingInfo<Product>> = {
        let items = [
            Product().with { $0.id = 1 }
        ]
        let page = PagingInfo<Product>(page: 1, items: items)
        return Observable.just(page)
    }()
    
    func getProductList() -> Observable<PagingInfo<Product>> {
        getProductListCalled = true
        return getProductListReturnValue
    }

    // MARK: - loadMoreProductList
    
    var loadMoreProductListCalled = false
    
    var loadMoreProductListReturnValue: Observable<PagingInfo<Product>> = {
        let items = [
            Product().with { $0.id = 2 }
        ]
        let page = PagingInfo<Product>(page: 2, items: items)
        return Observable.just(page)
    }()
    
    func loadMoreProductList(page: Int) -> Observable<PagingInfo<Product>> {
        loadMoreProductListCalled = true
        return loadMoreProductListReturnValue
    }
    
    // MARK: - deleteProduct
    
    var deleteProductCalled = false
    var deleteProductReturnValue: Observable<Void> = Observable.empty()
    
    func deleteProduct(id: Int) -> Observable<Void> {
        deleteProductCalled = true
        return deleteProductReturnValue
    }
}
