//
//  ProductDetailViewModel.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/22/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

struct ProductDetailViewModel {
    let navigator: ProductDetailNavigatorType
    let useCase: ProductDetailUseCaseType
    let product: Product
}

// MARK: - ViewModel
extension ProductDetailViewModel: ViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
    }

    struct Output {
        @Property var cells = [Cell]()
    }

    enum Cell {
        case name(String)
        case price(String)
    }

    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.loadTrigger
            .map { self.product }
            .map { product -> [Cell] in
                return [
                    Cell.name(product.name),
                    Cell.price(product.price.currency)
                ]
            }
            .drive(output.$cells)
            .disposed(by: disposeBag)
        
        return output
    }
}
