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
    func getProductList() -> Observable<PagingInfo<Product>> {
        return loadMoreProductList(page: 1)
    }

    func loadMoreProductList(page: Int) -> Observable<PagingInfo<Product>> {
        return Observable.create { observer in
            let products = Array(0...9)
                .map { $0 + (page - 1) * 10 }
                .map { id in
                    Product().with {
                        $0.id = id
                        $0.name = "Product \(id)"
                        $0.price = Double(id * 2)
                    }
            }
            let page = PagingInfo<Product>(page: page, items: OrderedSet<Product>(sequence: products))
            observer.onNext(page)
            observer.onCompleted()
            return Disposables.create()
        }
    }
}

