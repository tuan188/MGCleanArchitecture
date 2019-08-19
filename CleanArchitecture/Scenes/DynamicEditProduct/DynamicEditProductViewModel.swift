//
//  DynamicEditProductViewModel.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 9/10/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

struct DynamicEditProductViewModel {
    let navigator: DynamicEditProductNavigatorType
    let useCase: DynamicEditProductUseCaseType
    let product: Product
}

// MARK: - ViewModelType
extension DynamicEditProductViewModel: ViewModelType {
    struct Input {
        let loadTrigger: Driver<TriggerType>
        let updateTrigger: Driver<Void>
        let cancelTrigger: Driver<Void>
        let dataTrigger: Driver<DataType>
    }

    struct Output {
        let nameValidation: Driver<ValidationResult>
        let priceValidation: Driver<ValidationResult>
        let isUpdateEnabled: Driver<Bool>
        let updatedProduct: Driver<Void>
        let cancel: Driver<Void>
        let error: Driver<Error>
        let isLoading: Driver<Bool>
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
        
        let nameValidation = validate(object: name,
                                      trigger: input.updateTrigger,
                                      validator: useCase.validate(name:))
        
        let priceValidation = validate(object: price,
                                       trigger: input.updateTrigger,
                                       validator: useCase.validate(price:))
        
        let isUpdateEnabled = Driver.combineLatest([
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
                Product(
                    id: self.product.id,
                    name: name,
                    price: Double(price) ?? 0.0
                )
            }
        
        let cells = input.loadTrigger
            .withLatestFrom(Driver.combineLatest(product, nameValidation, priceValidation))
            .map { product, nameValidation, priceValidation -> [CellType] in
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
            .withLatestFrom(isUpdateEnabled)
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
                self.useCase.notifyUpdated(product)
                self.navigator.dismiss()
            })
            .mapToVoid()
        
        let error = errorTracker.asDriver()
        let isLoading = activityIndicator.asDriver()
        
        return Output(
            nameValidation: nameValidation,
            priceValidation: priceValidation,
            isUpdateEnabled: isUpdateEnabled,
            updatedProduct: updatedProduct,
            cancel: cancel,
            error: error,
            isLoading: isLoading,
            cells: cells
        )
    }
}
