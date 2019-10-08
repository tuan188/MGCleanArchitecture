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

struct DynamicEditProductUseCase: DynamicEditProductUseCaseType {
    let productRepository: ProductRepositoryType
    
    func validate(name: String) -> ValidationResult {
        let minLengthRule = ValidationRuleLength(min: 5, error: ProductValidationError.productNameMinLength)
        return name.validate(rule: minLengthRule)
    }
    
    func validate(price: String) -> ValidationResult {
        let priceNumber = Double(price) ?? 0.0
        if priceNumber <= 0 {
            return ValidationResult.invalid([ProductValidationError.productPriceMinValue])
        }
        return ValidationResult.valid
    }
    
    func update(_ product: Product) -> Observable<Void> {
        print(product.name, product.price)
        return productRepository.update(product)
    }
    
    func notifyUpdated(_ product: Product) {
        NotificationCenter.default.post(name: Notification.Name.updatedProduct, object: product)
    }
}
