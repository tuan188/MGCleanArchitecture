//
//  ProductDetailAssembler.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 7/15/18.
//  Copyright © 2018 Framgia. All rights reserved.
//

import UIKit

protocol ProductDetailAssembler {
    func resolve(navigationController: UINavigationController, product: Product) -> ProductDetailViewController
    func resolve(navigationController: UINavigationController, product: Product) -> ProductDetailViewModel
    func resolve(navigationController: UINavigationController) -> ProductDetailNavigatorType
    func resolve() -> ProductDetailUseCaseType
}

extension ProductDetailAssembler {
    func resolve(navigationController: UINavigationController, product: Product) -> ProductDetailViewController {
        let vc = ProductDetailViewController.instantiate()
        let vm: ProductDetailViewModel = resolve(navigationController: navigationController, product: product)
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve(navigationController: UINavigationController, product: Product) -> ProductDetailViewModel {
        return ProductDetailViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve(),
            product: product)
    }
}

extension ProductDetailAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> ProductDetailNavigatorType {
        return ProductDetailNavigator(assembler: self, navigationController: navigationController)
    }
    
    func resolve() -> ProductDetailUseCaseType {
        return ProductDetailUseCase()
    }
}
