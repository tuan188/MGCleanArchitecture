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
        let navigator = MainNavigator()
        let useCase = MainUseCase()
        let vm = MainViewModel(navigator: navigator, useCase: useCase)
        let vc = MainViewController.instantiate()
        vc.bindViewModel(to: vm)
        let nav = UINavigationController(rootViewController: vc)
        window.rootViewController = nav
    }
}
