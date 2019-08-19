//
//  EditProductViewModel.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/24/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

enum EditProductDelegate {
    case updatedProduct(Product)
}

struct EditProductViewModel {
    let navigator: EditProductNavigatorType
    let useCase: EditProductUseCaseType
    let product: Product
    let delegate: PublishSubject<EditProductDelegate> // swiftlint:disable:this weak_delegate
}

// MARK: - ViewModelType
extension EditProductViewModel: ViewModelType {
    struct Input {
        let loadTrigger: Driver<Void>
        let nameTrigger: Driver<String>
        let priceTrigger: Driver<String>
        let updateTrigger: Driver<Void>
        let cancelTrigger: Driver<Void>
    }

    struct Output {
        let name: Driver<String>
        let price: Driver<Double>
        let nameValidation: Driver<ValidationResult>
        let priceValidation: Driver<ValidationResult>
        let isUpdateEnabled: Driver<Bool>
        let updatedProduct: Driver<Void>
        let cancel: Driver<Void>
        let error: Driver<Error>
        let isLoading: Driver<Bool>
    }

    func transform(_ input: Input) -> Output {
        let errorTracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()
        
        let name = input.loadTrigger
            .map { self.product.name }
        
        let price = input.loadTrigger
            .map { self.product.price }
        
        let nameValidation = validate(object: input.nameTrigger,
                                      trigger: input.updateTrigger,
                                      validator: useCase.validate(name:))
        
        let priceValidation = validate(object: input.priceTrigger,
                                       trigger: input.updateTrigger,
                                       validator: useCase.validate(price:))
        
        let isUpdateEnabled = Driver.and(
            nameValidation.map { $0.isValid },
            priceValidation.map { $0.isValid }
        )
        .startWith(true)
        
        let updatedProduct = input.updateTrigger
            .withLatestFrom(isUpdateEnabled)
            .filter { $0 }
            .withLatestFrom(Driver.combineLatest(
                input.nameTrigger,
                input.priceTrigger
            ))
            .flatMapLatest { name, price -> Driver<Product> in
                let product = self.product.with {
                    $0.name = name
                    $0.price = Double(price) ?? 0.0
                }
                return self.useCase.update(product)
                    .trackError(errorTracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
                    .map { _ in product }
            }
            .do(onNext: { product in
                self.delegate.onNext(EditProductDelegate.updatedProduct(product))
                self.navigator.dismiss()
            })
            .mapToVoid()
        
        let cancel = input.cancelTrigger
            .do(onNext: navigator.dismiss)
        
        let error = errorTracker.asDriver()
        let isLoading = activityIndicator.asDriver()
        
        return Output(
            name: name,
            price: price,
            nameValidation: nameValidation,
            priceValidation: priceValidation,
            isUpdateEnabled: isUpdateEnabled,
            updatedProduct: updatedProduct,
            cancel: cancel,
            error: error,
            isLoading: isLoading
        )
    }
}
