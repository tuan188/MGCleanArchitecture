//
//  SectionedProductsNavigator.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/7/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

protocol SectionedProductsNavigatorType {
    func toProductDetail(product: Product)
    func toEditProduct(_ product: Product)
}

struct SectionedProductsNavigator: SectionedProductsNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController
    
    func toProductDetail(product: Product) {
        let vc: StaticProductDetailViewController = assembler
            .resolve(navigationController: navigationController, product: product)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toEditProduct(_ product: Product) {
        let nav = UINavigationController()
        let vc: DynamicEditProductViewController = assembler
            .resolve(navigationController: nav, product: product)
        nav.viewControllers = [vc]
        navigationController.present(nav, animated: true, completion: nil)
    }
}

