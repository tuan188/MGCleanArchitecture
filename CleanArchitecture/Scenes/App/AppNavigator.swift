//
// AppNavigator.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/4/18.
// Copyright © 2018 Framgia. All rights reserved.
//

protocol AppNavigatorType {
    func toMain()
}

struct AppNavigator: AppNavigatorType {
    unowned let window: UIWindow
    
    func toMain() {
        let vc = MainViewController.instantiate()
        let nav = UINavigationController(rootViewController: vc)
        let navigator = MainNavigator(navigationController: nav)
        let useCase = MainUseCase()
        let vm = MainViewModel(navigator: navigator, useCase: useCase)
        vc.bindViewModel(to: vm)
        window.rootViewController = nav
    }
}
