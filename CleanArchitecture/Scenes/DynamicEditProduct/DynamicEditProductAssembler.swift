//
// DynamicEditProductAssembler.swift
// CleanArchitecture
//
// Created by Tuan Truong on 9/10/18.
// Copyright © 2018 Framgia. All rights reserved.
//

import UIKit

protocol DynamicEditProductAssembler {
    func resolve(navigationController: UINavigationController, product: Product) -> DynamicEditProductViewController
    func resolve(navigationController: UINavigationController, product: Product) -> DynamicEditProductViewModel
    func resolve(navigationController: UINavigationController) -> DynamicEditProductNavigatorType
    func resolve() -> DynamicEditProductUseCaseType
}

extension DynamicEditProductAssembler {
    func resolve(navigationController: UINavigationController, product: Product) -> DynamicEditProductViewController {
        let vc = DynamicEditProductViewController.instantiate()
        let vm: DynamicEditProductViewModel = resolve(navigationController: navigationController, product: product)
        vc.bindViewModel(to: vm)
        return vc
    }

    func resolve(navigationController: UINavigationController, product: Product) -> DynamicEditProductViewModel {
        return DynamicEditProductViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve(),
            product: product
        )
    }
}

extension DynamicEditProductAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> DynamicEditProductNavigatorType {
        return DynamicEditProductNavigator(assembler: self, navigationController: navigationController)
    }

    func resolve() -> DynamicEditProductUseCaseType {
        return DynamicEditProductUseCase(productRepository: resolve())
    }
}
