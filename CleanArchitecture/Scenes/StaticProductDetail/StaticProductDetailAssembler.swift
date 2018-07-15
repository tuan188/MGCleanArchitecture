//
//  StaticProductDetailAssembler.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 7/15/18.
//  Copyright © 2018 Framgia. All rights reserved.
//

import UIKit

protocol StaticProductDetailAssembler {
    func resolve(navigationController: UINavigationController, product: Product) -> StaticProductDetailViewController
    func resolve(navigationController: UINavigationController, product: Product) -> StaticProductDetailViewModel
    func resolve(navigationController: UINavigationController) -> StaticProductDetailNavigatorType
    func resolve() -> StaticProductDetailUseCaseType
}

extension StaticProductDetailAssembler {
    func resolve(navigationController: UINavigationController, product: Product) -> StaticProductDetailViewController {
        let vc = StaticProductDetailViewController.instantiate()
        let vm: StaticProductDetailViewModel = resolve(navigationController: navigationController, product: product)
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve(navigationController: UINavigationController, product: Product) -> StaticProductDetailViewModel {
        return StaticProductDetailViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve(),
            product: product
        )
    }
}

extension StaticProductDetailAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> StaticProductDetailNavigatorType {
        return StaticProductDetailNavigator(assembler: self, navigationController: navigationController)
    }
    
    func resolve() -> StaticProductDetailUseCaseType {
        return StaticProductDetailUseCase()
    }
}
