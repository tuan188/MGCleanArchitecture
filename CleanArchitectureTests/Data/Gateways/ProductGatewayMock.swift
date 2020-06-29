//
//  ProductGatewayMock.swift
//  CleanArchitectureTests
//
//  Created by Tuan Truong on 6/29/20.
//  Copyright © 2020 Sun Asterisk. All rights reserved.
//

@testable import CleanArchitecture
import UIKit

final class ProductGatewayMock: ProductGatewayType {

    // MARK: - getProductList

    var getProductListCalled = false
    var getProductListReturnValue = Observable<PagingInfo<Product>>.just(
        PagingInfo(page: 1, items: [Product()])
    )

    func getProductList(page: Int) -> Observable<PagingInfo<Product>> {
        getProductListCalled = true
        return getProductListReturnValue
    }

    // MARK: - deleteProduct

    var deleteProductCalled = false
    var deleteProductReturnValue = Observable.just(())

    func deleteProduct(id: Int) -> Observable<Void> {
        deleteProductCalled = true
        return deleteProductReturnValue
    }

    // MARK: - update

    var updateCalled = false
    var updateReturnValue = Observable.just(())

    func update(_ product: Product) -> Observable<Void> {
        updateCalled = true
        return updateReturnValue
    }
}
