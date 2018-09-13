//
// DynamicEditProductViewModel.swift
// CleanArchitecture
//
// Created by Tuan Truong on 9/10/18.
// Copyright © 2018 Framgia. All rights reserved.
//

struct DynamicEditProductViewModel: ViewModelType {
    struct Input {
        let loadTrigger: Driver<TriggerType>
        let updateTrigger: Driver<Void>
        let cancelTrigger: Driver<Void>
        let dataTrigger: Driver<DataType>
    }

    struct Output {
        let nameValidation: Driver<ValidationResult>
        let priceValidation: Driver<ValidationResult>
        let updateEnable: Driver<Bool>
        let updatedProduct: Driver<Void>
        let cancel: Driver<Void>
        let error: Driver<Error>
        let loading: Driver<Bool>
        let cells: Driver<([CellType], Bool)>
    }
    
    enum DataType {
        case name(String)
        case price(String)
    }
    
    struct CellType {
        let dataType: DataType
        let validationResult: ValidationResult
    }
    
    enum TriggerType {
        case load
        case endEditing
    }

    let navigator: DynamicEditProductNavigatorType
    let useCase: DynamicEditProductUseCaseType
    let product: Product

    func transform(_ input: Input) -> Output {
        let errorTracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()
        
        let name = input.dataTrigger
            .map { data -> String? in
                if case let DataType.name(name) = data {
                    return name
                }
                return nil
            }
            .unwrap()
            .startWith(self.product.name)
        
        let price = input.dataTrigger
            .map { data -> String? in
                if case let DataType.price(price) = data {
                    return price
                }
                return nil
            }
            .unwrap()
            .startWith(String(self.product.price))
        
        let nameValidation = Driver.combineLatest(name, input.updateTrigger)
            .map { $0.0 }
            .map { name -> ValidationResult in
                self.useCase.validate(name: name)
            }
            .startWith(.valid)
        
        let priceValidation = Driver.combineLatest(price, input.updateTrigger)
            .map { $0.0 }
            .map { price -> ValidationResult in
                self.useCase.validate(price: price)
            }
            .startWith(.valid)
        
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
        
        let product = Driver.combineLatest(name, price)
            .map { name, price in
                Product(id: self.product.id, name: name, price: Double(price) ?? 0.0)
            }
        
        let cells = input.loadTrigger
            .withLatestFrom(Driver.combineLatest(product, nameValidation, priceValidation))
            .map { params -> [CellType] in
                let (product, nameValidation, priceValidation) = params
                return [
                    CellType(dataType: .name(product.name), validationResult: nameValidation),
                    CellType(dataType: .price(String(product.price)), validationResult: priceValidation)
                ]
            }
            .withLatestFrom(input.loadTrigger) {
                ($0, $1 == .load)
            }
        
        let cancel = input.cancelTrigger
            .do(onNext: navigator.dismiss)
        
        let updatedProduct = input.updateTrigger
            .withLatestFrom(updateEnable)
            .filter { $0 }
            .withLatestFrom(product)
            .flatMapLatest { product in
                self.useCase.update(product)
                    .trackError(errorTracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
                    .map { _ in product }
            }
            .do(onNext: { product in
                NotificationCenter.default.post(name: Notification.Name.updatedProduct, object: product)
                self.navigator.dismiss()
            })
            .mapToVoid()
        
        let error = errorTracker.asDriver()
        let loading = activityIndicator.asDriver()
        
        return Output(
            nameValidation: nameValidation,
            priceValidation: priceValidation,
            updateEnable: updateEnable,
            updatedProduct: updatedProduct,
            cancel: cancel,
            error: error,
            loading: loading,
            cells: cells
        )
    }
}
