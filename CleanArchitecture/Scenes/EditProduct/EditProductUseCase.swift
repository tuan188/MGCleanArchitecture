//
//  EditProductUseCase.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/24/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

protocol EditProductUseCaseType {
    func validate(name: String) -> ValidationResult
    func validate(price: String) -> ValidationResult
    func update(_ product: Product) -> Observable<Void>
}

struct EditProductUseCase: EditProductUseCaseType, ValidatingProductName, ValidatingProductPrice, UpdatingProduct {
    let productGateway: ProductGatewayType
    
    func validate(name: String) -> ValidationResult {
        return validateProductName(name)
    }
    
    func validate(price: String) -> ValidationResult {
        return validateProductPrice(price)
    }
    
    func update(_ product: Product) -> Observable<Void> {
        return updateProduct(product)
    }
}
