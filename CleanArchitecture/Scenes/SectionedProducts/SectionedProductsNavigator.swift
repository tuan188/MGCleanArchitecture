//
// SectionedProductsNavigator.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/7/18.
// Copyright © 2018 Framgia. All rights reserved.
//

protocol SectionedProductsNavigatorType {
    func toSectionedProducts()
    func toProductDetail(product: Product)
}

struct SectionedProductsNavigator: SectionedProductsNavigatorType {
    unowned let navigationController: UINavigationController
    
    func toSectionedProducts() {
        let vc = SectionedProductsViewController.instantiate()
        let vm = SectionedProductsViewModel(navigator: self, useCase: SectionedProductsUseCase())
        vc.bindViewModel(to: vm)
        navigationController.pushViewController(vc, animated: true)
    }

    func toProductDetail(product: Product) {
        let navigator = StaticProductDetailNavigator(navigationController: navigationController)
        navigator.toStaticProductDetail(product: product)
    }
}

