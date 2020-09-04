//
//  StaticProductDetailViewModel.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/24/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

struct StaticProductDetailViewModel {
    let navigator: StaticProductDetailNavigatorType
    let useCase: StaticProductDetailUseCaseType
    let product: Product
}

// MARK: - ViewModel
extension StaticProductDetailViewModel: ViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
    }

    struct Output {
        @Property var name = ""
        @Property var price = ""
    }

    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        let product = input.loadTrigger
            .map { self.product }
        
        product.map { $0.name }
            .drive(output.$name)
            .disposed(by: disposeBag)
        
        product.map { $0.price.currency }
            .drive(output.$price)
            .disposed(by: disposeBag)
        
        return output
    }
}
