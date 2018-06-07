//
// MainNavigator.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/4/18.
// Copyright © 2018 Framgia. All rights reserved.
//

protocol MainNavigatorType {
    func toLogin()
    func toProducts()
    func toSectionedProducts()
}

struct MainNavigator: MainNavigatorType {
    unowned let navigationController: UINavigationController
    
    func toLogin() {
        
    }
    
    func toProducts() {
        let navigator = ProductsNavigator(navigationController: navigationController)
        navigator.toProducts()
    }
    
    func toSectionedProducts() {
        let navigator = SectionedProductsNavigator(navigationController: navigationController)
        navigator.toSectionedProducts()
    }
}

