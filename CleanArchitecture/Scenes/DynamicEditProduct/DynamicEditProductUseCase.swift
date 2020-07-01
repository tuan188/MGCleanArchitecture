//
//  DynamicEditProductUseCase.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 9/10/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

protocol DynamicEditProductUseCaseType {
    func validate(name: String) -> ValidationResult
    func validate(price: String) -> ValidationResult
    func update(_ product: Product) -> Observable<Void>
    func notifyUpdated(_ product: Product)
}

struct DynamicEditProductUseCase: DynamicEditProductUseCaseType,
    ValidatingProductName,
    ValidatingProductPrice,
    UpdatingProduct {
    
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
    
    func notifyUpdated(_ product: Product) {
        NotificationCenter.default.post(name: Notification.Name.updatedProduct, object: product)
    }
}
