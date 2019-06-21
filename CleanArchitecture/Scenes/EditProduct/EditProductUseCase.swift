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

struct EditProductUseCase: EditProductUseCaseType {
    let productRepository: ProductRepositoryType
    
    func validate(name: String) -> ValidationResult {
        let minLengthRule = ValidationRuleLength(min: 5, error: ValidationError.productNameMinLength)
        return name.validate(rule: minLengthRule)
    }
    
    func validate(price: String) -> ValidationResult {
        let priceNumber = Double(price) ?? 0.0
        if priceNumber <= 0 {
            return ValidationResult.invalid([ValidationError.productPriceMinValue])
        }
        return ValidationResult.valid
    }
    
    func update(_ product: Product) -> Observable<Void> {
        return productRepository.update(product)
    }
}
