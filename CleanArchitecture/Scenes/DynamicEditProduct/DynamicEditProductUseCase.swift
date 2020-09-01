//
//  DynamicEditProductUseCase.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 9/10/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

import ValidatedPropertyKit

protocol DynamicEditProductUseCaseType {
    func validateName(_ name: String) -> ValidationResult
    func validatePrice(_ price: String) -> ValidationResult
    func update(_ product: ProductDto) -> Observable<Void>
    func notifyUpdated(_ product: Product)
}

struct DynamicEditProductUseCase: DynamicEditProductUseCaseType, UpdatingProduct {
    
    let productGateway: ProductGatewayType
    
    func validateName(_ name: String) -> ValidationResult {
        return ProductDto.validateName(name).mapToVoid()
    }
    
    func validatePrice(_ price: String) -> ValidationResult {
        return ProductDto.validatePriceString(price).mapToVoid()
    }
    
    func update(_ product: ProductDto) -> Observable<Void> {
        if let error = product.validationError {
            return Observable.error(error)
        }
        
        return updateProduct(product)
    }
    
    func notifyUpdated(_ product: Product) {
        NotificationCenter.default.post(name: Notification.Name.updatedProduct, object: product)
    }
}
