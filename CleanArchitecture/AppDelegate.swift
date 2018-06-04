//
//  AppDelegate.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/4/18.
//  Copyright © 2018 Framgia. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        bindViewModel()
        return true
    }

    private func bindViewModel() {
        guard let window = window else { return }
        let navigator = AppNavigator(window: window)
        let useCase = AppUseCase()
        let vm = AppViewModel(navigator: navigator, useCase: useCase)
        let input = AppViewModel.Input(loadTrigger: Driver.just(()))
        let output = vm.transform(input)
        output.toMain.drive().disposed(by: rx.disposeBag)
    }
}

