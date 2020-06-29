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

struct ProductsUseCase: ProductsUseCaseType, GettingProductList, DeletingProduct {
    let productGateway: ProductGatewayType
}

