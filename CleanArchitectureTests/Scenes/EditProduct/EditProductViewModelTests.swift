//
// EditProductViewModelTests.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/24/18.
// Copyright © 2018 Framgia. All rights reserved.
//

@testable import CleanArchitecture
import XCTest
import RxSwift
import RxBlocking

final class EditProductViewModelTests: XCTestCase {
    
    private var viewModel: EditProductViewModel!
    private var navigator: EditProductNavigatorMock!
    private var useCase: EditProductUseCaseMock!
    
    private var input: EditProductViewModel.Input!
    private var output: EditProductViewModel.Output!
    
    private var disposeBag: DisposeBag!
    
    private let nameTrigger = PublishSubject<String>()
    private let priceTrigger = PublishSubject<String>()
    private let loadTrigger = PublishSubject<Void>()
    private let updateTrigger = PublishSubject<Void>()
    private let cancelTrigger = PublishSubject<Void>()
    
    private let delegate = PublishSubject<EditProductDelegate>() // swiftlint:disable:this weak_delegate
    
    private var product: Product!
    
    override func setUp() {
        super.setUp()
        navigator = EditProductNavigatorMock()
        useCase = EditProductUseCaseMock()
        product = Product(id: 1, name: "foobar", price: 10)
        viewModel = EditProductViewModel(navigator: navigator, useCase: useCase, product: product, delegate: delegate)
        
        input = EditProductViewModel.Input(
            loadTrigger: loadTrigger.asDriverOnErrorJustComplete(),
            nameTrigger: nameTrigger.asDriverOnErrorJustComplete(),
            priceTrigger: priceTrigger.asDriverOnErrorJustComplete(),
            updateTrigger: updateTrigger.asDriverOnErrorJustComplete(),
            cancelTrigger: cancelTrigger.asDriverOnErrorJustComplete()
        )
        
        output = viewModel.transform(input)
        
        disposeBag = DisposeBag()
        
        output.name.drive().disposed(by: disposeBag)
        output.price.drive().disposed(by: disposeBag)
        output.nameValidation.drive().disposed(by: disposeBag)
        output.priceValidation.drive().disposed(by: disposeBag)
        output.isUpdateEnabled.drive().disposed(by: disposeBag)
        output.updatedProduct.drive().disposed(by: disposeBag)
        output.cancel.drive().disposed(by: disposeBag)
        output.error.drive().disposed(by: disposeBag)
        output.isLoading.drive().disposed(by: disposeBag)
    }
    
    func test_loadTriggerInvoked_showProduct() {
        // act
        loadTrigger.onNext(())
        let name = try? output.name.toBlocking(timeout: 1).first()
        let price = try? output.price.toBlocking(timeout: 1).first()
        
        // assert
        XCTAssertEqual(name, product.name)
        XCTAssertEqual(price, product.price)
    }
    
    func test_loadTriggerInvoked_enableUpdateByDefault() {
        // act
        loadTrigger.onNext(())
        let updateEnable = try? output.isUpdateEnabled.toBlocking(timeout: 1).first()
        
        // assert
        XCTAssertEqual(updateEnable, true)
    }
    
    func test_nameTriggerInvoked_validateName() {
        // act
        nameTrigger.onNext("foo")
        updateTrigger.onNext(())
        
        // assert
        XCTAssert(useCase.validateNameCalled)
    }
    
    func test_nameTriggerInvoked_validateNameFailNotEnableUpdate() {
        // arrange
        useCase.validateNameReturnValue = ValidationResult.invalid([TestError()])
        
        // act
        nameTrigger.onNext("foo")
        priceTrigger.onNext("10")
        updateTrigger.onNext(())
        let updateEnable = try? output.isUpdateEnabled.toBlocking(timeout: 1).first()
        
        // assert
        XCTAssertEqual(updateEnable, false)
    }
    
    func test_priceTriggerInvoked_validatePrice() {
        // act
        priceTrigger.onNext("10")
        updateTrigger.onNext(())
        
        // assert
        XCTAssert(useCase.validatePriceCalled)
    }
    
    func test_priceTriggerInvoked_validatePriceFailNotEnableUpdate() {
        // arrange
        useCase.validatePriceReturnValue = ValidationResult.invalid([TestError()])
        
        // act
        nameTrigger.onNext("foo")
        priceTrigger.onNext("10")
        updateTrigger.onNext(())
        let updateEnable = try? output.isUpdateEnabled.toBlocking(timeout: 1).first()
        
        // assert
        XCTAssertEqual(updateEnable, false)
    }
    
    func test_enableUpdate() {
        // act
        nameTrigger.onNext("foo")
        priceTrigger.onNext("10")
        updateTrigger.onNext(())
        let updateEnable = try? output.isUpdateEnabled.toBlocking(timeout: 1).first()
        
        // assert
        XCTAssertEqual(updateEnable, true)
    }
    
    func test_updateTriggerInvoked_notUpdateProduct() {
        // arrange
        useCase.validateNameReturnValue = ValidationResult.invalid([TestError()])
        
        // act
        nameTrigger.onNext("foo")
        priceTrigger.onNext("10")
        updateTrigger.onNext(())
        
        // assert
        XCTAssertFalse(useCase.updateCalled)
    }
    
    func test_updateTriggerInvoked_updateProduct() {
        // act
        nameTrigger.onNext("foo")
        priceTrigger.onNext("10")
        updateTrigger.onNext(())
        
        // assert
        XCTAssert(useCase.updateCalled)
        XCTAssert(navigator.dismissCalled)
    }
    
    func test_updateTriggerInvoked_updateProductFailShowError() {
        // arrange
        useCase.updateReturnValue = Observable.error(TestError())
        
        // act
        nameTrigger.onNext("foo")
        priceTrigger.onNext("10")
        updateTrigger.onNext(())
        let error = try? output.error.toBlocking(timeout: 1).first()
        
        // assert
        XCTAssert(useCase.updateCalled)
        XCTAssertFalse(navigator.dismissCalled)
        XCTAssert(error is TestError)
    }
    
    func test_cancelTriggerInvoked_dismiss() {
        // act
        cancelTrigger.onNext(())
        
        // assert
        XCTAssert(navigator.dismissCalled)
    }
    
}
