//
// ProductDetailNavigator.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/22/18.
// Copyright © 2018 Framgia. All rights reserved.
//

protocol ProductDetailNavigatorType {
    func toProductDetail(product: Product)
}

struct ProductDetailNavigator: ProductDetailNavigatorType {
    unowned let navigationController: UINavigationController
    
    func toProductDetail(product: Product) {
        let useCase = ProductDetailUseCase()
        let vm = ProductDetailViewModel(navigator: self, useCase: useCase, product: product)
        let vc = ProductDetailViewController.instantiate()
        vc.bindViewModel(to: vm)
        navigationController.pushViewController(vc, animated: true)
    }
}
