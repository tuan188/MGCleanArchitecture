//
// ProductDetailViewModel.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/22/18.
// Copyright © 2018 Framgia. All rights reserved.
//

struct ProductDetailViewModel {
    let navigator: ProductDetailNavigatorType
    let useCase: ProductDetailUseCaseType
    let product: Product
}

// MARK: - ViewModelType
extension ProductDetailViewModel: ViewModelType {
    struct Input {
        let loadTrigger: Driver<Void>
    }

    struct Output {
        let cells: Driver<[CellType]>
    }

    enum CellType {
        case name(String)
        case price(String)
    }

    func transform(_ input: Input) -> Output {
        let product = input.loadTrigger
            .map { self.product }
        let cells = product
            .map { product -> [CellType] in
                var cells = [CellType]()
                cells.append(CellType.name(product.name))
                cells.append(CellType.price(product.price.currency))
                return cells
            }
        return Output(cells: cells)
    }
}
