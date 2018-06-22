//
// ProductsNavigator.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/5/18.
// Copyright © 2018 Framgia. All rights reserved.
//

protocol ProductsNavigatorType {
    func toProducts()
    func toProductDetail(product: Product)
}

struct ProductsNavigator: ProductsNavigatorType {
    unowned let navigationController: UINavigationController
    
    func toProducts() {
        let vc = ProductsViewController.instantiate()
        let vm = ProductsViewModel(navigator: self, useCase: ProductsUseCase())
        vc.bindViewModel(to: vm)
        navigationController.pushViewController(vc, animated: true)
    }

    func toProductDetail(product: Product) {
        let navigator = ProductDetailNavigator(navigationController: navigationController)
        navigator.toProductDetail(product: product)
    }
}

