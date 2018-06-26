//
// EditProductUseCaseMock.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/24/18.
// Copyright © 2018 Framgia. All rights reserved.
//

@testable import CleanArchitecture
import RxSwift

final class EditProductUseCaseMock: EditProductUseCaseType {
    
    // MARK: - validate
    var validateName_Called = false
    var validateName_ReturnValue: ValidationResult = ValidationResult.valid
    
    func validate(name: String) -> ValidationResult {
        validateName_Called = true
        return validateName_ReturnValue
    }
    
    // MARK: - validate
    var validatePrice_Called = false
    var validatePrice_ReturnValue: ValidationResult = ValidationResult.valid
    
    func validate(price: String) -> ValidationResult {
        validatePrice_Called = true
        return validatePrice_ReturnValue
    }
    
    // MARK: - save
    var update_Called = false
    var update_ReturnValue: Observable<Void> = Observable.just(())
    
    func update(_ product: Product) -> Observable<Void> {
        update_Called = true
        return update_ReturnValue
    }
    
}

