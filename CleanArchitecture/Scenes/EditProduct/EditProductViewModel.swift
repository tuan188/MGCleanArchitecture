//
//  EditProductViewModel.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/24/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

import ValidatedPropertyKit

enum EditProductDelegate {
    case updatedProduct(Product)
}

struct EditProductViewModel {
    let navigator: EditProductNavigatorType
    let useCase: EditProductUseCaseType
    let product: Product
    let delegate: PublishSubject<EditProductDelegate> // swiftlint:disable:this weak_delegate
}

// MARK: - ViewModel
extension EditProductViewModel: ViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
        let name: Driver<String>
        let price: Driver<String>
        let updateTrigger: Driver<Void>
        let cancelTrigger: Driver<Void>
    }

    struct Output {
        @Property var name = ""
        @Property var price = 0.0
        @Property var nameValidation = ValidationResult.success(())
        @Property var priceValidation = ValidationResult.success(())
        @Property var isUpdateEnabled = true
        @Property var error: Error?
        @Property var isLoading = false
    }

    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        var output = Output(name: product.name, price: product.price)
        let errorTracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()
        
        let name = Driver.merge(
            input.name,
            input.loadTrigger.map { self.product.name }
        )
        
        let price = Driver.merge(
            input.price,
            input.loadTrigger.map { String(self.product.price) }
        )
        
        let nameValidation = Driver.combineLatest(name, input.updateTrigger)
            .map { $0.0 }
            .map(useCase.validateName(_:))
            .do(onNext: { result in
                output.nameValidation = result
            })
        
        let priceValidation = Driver.combineLatest(price, input.updateTrigger)
            .map { $0.0 }
            .map(useCase.validatePrice(_:))
            .do(onNext: { result in
                output.priceValidation = result
            })
        
        let isUpdateEnabled = Driver.and(
            nameValidation.map { $0.isValid },
            priceValidation.map { $0.isValid }
        )
        .startWith(true)
        .do(onNext: { isEnabled in
            output.isUpdateEnabled = isEnabled
        })
        
        input.updateTrigger
            .withLatestFrom(isUpdateEnabled)
            .filter { $0 }
            .withLatestFrom(Driver.combineLatest(
                name,
                price
            ))
            .flatMapLatest { name, price -> Driver<Product> in
                let product = self.product.with {
                    $0.name = name
                    $0.price = Double(price) ?? 0.0
                }
                
                return self.useCase.update(product.toDto())
                    .trackError(errorTracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
                    .map { _ in product }
            }
            .do(onNext: { product in
                self.delegate.onNext(EditProductDelegate.updatedProduct(product))
                self.navigator.dismiss()
            })
            .drive()
            .disposed(by: disposeBag)
        
        input.cancelTrigger
            .do(onNext: navigator.dismiss)
            .drive()
            .disposed(by: disposeBag)
        
        errorTracker
            .asDriver()
            .drive(output.$error)
            .disposed(by: disposeBag)
            
        activityIndicator
            .asDriver()
            .drive(output.$isLoading)
            .disposed(by: disposeBag)
        
        return output
    }
}
