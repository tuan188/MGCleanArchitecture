//
//  SectionedProductsAssembler.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 7/15/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

import UIKit

protocol SectionedProductsAssembler {
    func resolve(navigationController: UINavigationController) -> SectionedProductsViewController
    func resolve(navigationController: UINavigationController) -> SectionedProductCollectionViewController
    func resolve(navigationController: UINavigationController) -> SectionedProductsViewModel
    func resolve(navigationController: UINavigationController) -> SectionedProductsNavigatorType
    func resolve() -> SectionedProductsUseCaseType
}

extension SectionedProductsAssembler {
    func resolve(navigationController: UINavigationController) -> SectionedProductsViewController {
        let vc = SectionedProductsViewController.instantiate()
        let vm: SectionedProductsViewModel = resolve(navigationController: navigationController)
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve(navigationController: UINavigationController) -> SectionedProductCollectionViewController {
        let vc = SectionedProductCollectionViewController.instantiate()
        let vm: SectionedProductsViewModel = resolve(navigationController: navigationController)
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve(navigationController: UINavigationController) -> SectionedProductsViewModel {
        return SectionedProductsViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve()
        )
    }
}

extension SectionedProductsAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> SectionedProductsNavigatorType {
        return SectionedProductsNavigator(assembler: self, navigationController: navigationController)
    }
    
    func resolve() -> SectionedProductsUseCaseType {
        return SectionedProductsUseCase(productGateway: resolve())
    }
}
