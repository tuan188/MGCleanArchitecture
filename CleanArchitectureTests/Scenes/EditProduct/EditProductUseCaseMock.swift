//
//  EditProductUseCaseMock.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/24/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

@testable import CleanArchitecture
import RxSwift
import Validator

final class EditProductUseCaseMock: EditProductUseCaseType {
    
    // MARK: - validate
    
    var validateNameCalled = false
    var validateNameReturnValue = ValidationResult.valid
    
    func validate(name: String) -> ValidationResult {
        validateNameCalled = true
        return validateNameReturnValue
    }
    
    // MARK: - validate
    var validatePriceCalled = false
    var validatePriceReturnValue = ValidationResult.valid
    
    func validate(price: String) -> ValidationResult {
        validatePriceCalled = true
        return validatePriceReturnValue
    }
    
    // MARK: - save
    var updateCalled = false
    var updateReturnValue: Observable<Void> = Observable.just(())
    
    func update(_ product: Product) -> Observable<Void> {
        updateCalled = true
        return updateReturnValue
    }
    
}

