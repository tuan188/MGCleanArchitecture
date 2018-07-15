//
// SectionedProductsNavigator.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/7/18.
// Copyright © 2018 Framgia. All rights reserved.
//

protocol SectionedProductsNavigatorType {
    func toProductDetail(product: Product)
}

struct SectionedProductsNavigator: SectionedProductsNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController
    
    func toProductDetail(product: Product) {
        let vc: StaticProductDetailViewController = assembler.resolve(navigationController: navigationController, product: product)
        navigationController.pushViewController(vc, animated: true)
    }
}

