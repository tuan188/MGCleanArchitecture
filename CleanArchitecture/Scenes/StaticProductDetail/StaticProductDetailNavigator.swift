//
// StaticProductDetailNavigator.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/22/18.
// Copyright © 2018 Framgia. All rights reserved.
//

protocol StaticProductDetailNavigatorType {
    func toStaticProductDetail(product: Product)
}

struct StaticProductDetailNavigator: StaticProductDetailNavigatorType {
    unowned let navigationController: UINavigationController
    
    func toStaticProductDetail(product: Product) {
        let useCase = StaticProductDetailUseCase()
        let vm = StaticProductDetailViewModel(navigator: self, useCase: useCase, product: product )
        let vc = StaticProductDetailViewController.instantiate()
        vc.bindViewModel(to: vm)
        navigationController.pushViewController(vc, animated: true)
    }
}
