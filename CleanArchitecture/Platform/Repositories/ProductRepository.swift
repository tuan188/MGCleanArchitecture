//
//  ProductRepository.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 7/23/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

import UIKit

protocol ProductRepositoryType {
    func getProductList(page: Int) -> Observable<PagingInfo<Product>>
    func deleteProduct(id: Int) -> Observable<Void>
    func update(_ product: Product) -> Observable<Void>
}

final class ProductRepository: ProductRepositoryType {
    func getProductList(page: Int) -> Observable<PagingInfo<Product>> {
        return Observable.create { observer in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5, execute: {
                let products = Array(0...9)
                    .map { $0 + (page - 1) * 10 }
                    .map { id in
                        Product().with {
                            $0.id = id
                            $0.name = "Product \(id)"
                            $0.price = Double(id * 2)
                        }
                    }
                let page = PagingInfo<Product>(page: page, items: products)
                observer.onNext(page)
                observer.onCompleted()
            })
            return Disposables.create()
        }
    }
    
    func deleteProduct(id: Int) -> Observable<Void> {
        return Observable.just(())
    }
    
    func update(_ product: Product) -> Observable<Void> {
        return Observable.just(())
    }
}

final class LocalProductRepository: ProductRepositoryType {
    func getProductList(page: Int) -> Observable<PagingInfo<Product>> {
        return API.shared.getProductList(API.GetProductListInput())
            .map { PagingInfo(page: 1, items: $0) }
    }
    
    func deleteProduct(id: Int) -> Observable<Void> {
        return Observable.just(())
    }
    
    func update(_ product: Product) -> Observable<Void> {
        return Observable.just(())
    }
}
