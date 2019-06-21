//
//  DynamicEditProductUseCaseMock.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 9/10/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

@testable import CleanArchitecture
import RxSwift

final class DynamicEditProductUseCaseMock: DynamicEditProductUseCaseType {
    
    // MARK: - validate name
    
    var validateNameCalled = false
    var validateNameReturnValue = ValidationResult.valid
    
    func validate(name: String) -> ValidationResult {
        validateNameCalled = true
        return validateNameReturnValue
    }
    
    // MARK: - validate price
    
    var validatePriceCalled = false
    var validatePriceReturnValue = ValidationResult.valid
    
    func validate(price: String) -> ValidationResult {
        validatePriceCalled = true
        return validatePriceReturnValue
    }
    
    // MARK: - update product
    
    var updateCalled = false
    var updateReturnValue: Observable<Void> = Observable.just(())
    
    func update(_ product: Product) -> Observable<Void> {
        updateCalled = true
        return updateReturnValue
    }
}

