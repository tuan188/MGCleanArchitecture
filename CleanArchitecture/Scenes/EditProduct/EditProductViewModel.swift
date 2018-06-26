//
// EditProductViewModel.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/24/18.
// Copyright © 2018 Framgia. All rights reserved.
//

enum EditProductDelegate {
    case updatedProduct(Product)
}

struct EditProductViewModel: ViewModelType {

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
        let updateEnable: Driver<Bool>
        let updatedProduct: Driver<Void>
        let cancel: Driver<Void>
        let error: Driver<Error>
        let loading: Driver<Bool>
    }

    let navigator: EditProductNavigatorType
    let useCase: EditProductUseCaseType
    let product: Product
    let delegate: PublishSubject<EditProductDelegate>

    func transform(_ input: Input) -> Output {
        let errorTracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()
        
        let name = input.loadTrigger
            .map { self.product.name }
        
        let price = input.loadTrigger
            .map { self.product.price }
        
        let nameValidation = Driver.combineLatest(
                input.nameTrigger,
                input.updateTrigger
            )
            .map { $0.0 }
            .map { name -> ValidationResult in
                self.useCase.validate(name: name)
            }
        
        let priceValidation = Driver.combineLatest(
                input.priceTrigger,
                input.updateTrigger
            )
            .map { $0.0 }
            .map { price -> ValidationResult in
                self.useCase.validate(price: price)
            }
        
        let updateEnable = Driver.combineLatest([
                nameValidation,
                priceValidation
            ])
            .map {
                $0.reduce(true) { result, validation -> Bool in
                    result && validation.isValid
                }
            }
            .startWith(true)
        
        let updatedProduct = input.updateTrigger
            .withLatestFrom(Driver.combineLatest(
                input.nameTrigger,
                input.priceTrigger
            ))
            .flatMapLatest { params -> Driver<Product> in
                let (name, price) = params
                let product = Product().with {
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
        let loading = activityIndicator.asDriver()
        
        return Output(
            name: name,
            price: price,
            nameValidation: nameValidation,
            priceValidation: priceValidation,
            updateEnable: updateEnable,
            updatedProduct: updatedProduct,
            cancel: cancel,
            error: error,
            loading: loading
        )
    }
}
