//
//  SectionedProductsUseCase.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/7/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

import RxSwift
import MGArchitecture

protocol SectionedProductsUseCaseType {
    func getProductList(page: Int) -> Observable<PagingInfo<Product>>
}

struct SectionedProductsUseCase: SectionedProductsUseCaseType, GettingProductList {
    let productGateway: ProductGatewayType
    
    func getProductList(page: Int) -> Observable<PagingInfo<Product>> {
        let dto = GetPageDto(page: page, perPage: 10, usingCache: true)
        return getProductList(dto: dto)
    }
}

