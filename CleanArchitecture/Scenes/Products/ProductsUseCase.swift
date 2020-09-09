//
//  ProductsUseCase.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/5/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

import RxSwift
import MGArchitecture

protocol ProductsUseCaseType {
    func getProductList(dto: GetPageDto) -> Observable<PagingInfo<Product>>
    func deleteProduct(dto: DeleteProductDto) -> Observable<Void>
}

struct ProductsUseCase: ProductsUseCaseType, GettingProductList, DeletingProduct {
    let productGateway: ProductGatewayType
}

