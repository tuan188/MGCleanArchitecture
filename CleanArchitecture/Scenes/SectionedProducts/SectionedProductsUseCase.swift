//
//  SectionedProductsUseCase.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/7/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

protocol SectionedProductsUseCaseType {
    func getProductList(page: Int) -> Observable<PagingInfo<Product>>
}

struct SectionedProductsUseCase: SectionedProductsUseCaseType, GettingProductList {
    let productGateway: ProductGatewayType
}

