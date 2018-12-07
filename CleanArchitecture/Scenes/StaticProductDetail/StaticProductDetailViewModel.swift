//
// StaticProductDetailViewModel.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/24/18.
// Copyright © 2018 Framgia. All rights reserved.
//

struct StaticProductDetailViewModel {
    let navigator: StaticProductDetailNavigatorType
    let useCase: StaticProductDetailUseCaseType
    let product: Product
}

// MARK: - ViewModelType
extension StaticProductDetailViewModel: ViewModelType {
    struct Input {
        let loadTrigger: Driver<Void>
    }

    struct Output {
        let name: Driver<String>
        let price: Driver<String>
    }

    func transform(_ input: Input) -> Output {
        let product = input.loadTrigger
            .map { self.product }
        
        let name = product.map { $0.name }
        let price = product.map { $0.price.currency }
        
        return Output(
            name: name,
            price: price
        )
    }
}
