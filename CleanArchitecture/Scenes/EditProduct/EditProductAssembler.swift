//
//  EditProductAssembler.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 7/15/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

import UIKit

protocol EditProductAssembler {
    func resolve(navigationController: UINavigationController,
                 product: Product,
                 delegate: PublishSubject<EditProductDelegate>) -> EditProductViewController
    func resolve(navigationController: UINavigationController,
                 product: Product,
                 delegate: PublishSubject<EditProductDelegate>) -> EditProductViewModel
    func resolve(navigationController: UINavigationController) -> EditProductNavigatorType
    func resolve() -> EditProductUseCaseType
}

extension EditProductAssembler {
    func resolve(navigationController: UINavigationController,
                 product: Product,
                 delegate: PublishSubject<EditProductDelegate>) -> EditProductViewController {
        let vc = EditProductViewController.instantiate()
        
        let vm: EditProductViewModel = resolve(navigationController: navigationController,
                                               product: product,
                                               delegate: delegate)
        
        vc.bindViewModel(to: vm)
        
        return vc
    }
    
    func resolve(navigationController: UINavigationController,
                 product: Product,
                 delegate: PublishSubject<EditProductDelegate>) -> EditProductViewModel {
        return EditProductViewModel(navigator: resolve(navigationController: navigationController),
                                    useCase: resolve(),
                                    product: product,
                                    delegate: delegate)
    }
}

extension EditProductAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> EditProductNavigatorType {
        return EditProductNavigator(assembler: self, navigationController: navigationController)
    }
    
    func resolve() -> EditProductUseCaseType {
        return EditProductUseCase(productRepository: ProductRepository())
    }
}
