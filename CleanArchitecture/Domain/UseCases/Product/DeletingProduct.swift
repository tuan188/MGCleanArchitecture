//
//  DeletingProduct.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/26/20.
//  Copyright © 2020 Sun Asterisk. All rights reserved.
//

import UIKit

protocol DeletingProduct {
    var productGateway: ProductGatewayType { get }
}

extension DeletingProduct {
    func deleteProduct(id: Int) -> Observable<Void> {
        return productGateway.deleteProduct(id: id)
    }
}
