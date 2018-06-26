//
// EditProductUseCase.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/24/18.
// Copyright © 2018 Framgia. All rights reserved.
//

protocol EditProductUseCaseType {
    func validate(name: String) -> ValidationResult
    func validate(price: String) -> ValidationResult
    func update(_ product: Product) -> Observable<Void>
}

struct EditProductUseCase: EditProductUseCaseType {
    
    func validate(name: String) -> ValidationResult {
        return ValidationResult.valid
    }
    
    func validate(price: String) -> ValidationResult {
        return ValidationResult.valid
    }
    
    func update(_ product: Product) -> Observable<Void> {
        return Observable.just(())
    }
    
}
