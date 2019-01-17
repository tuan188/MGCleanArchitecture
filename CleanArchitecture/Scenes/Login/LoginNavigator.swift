//
// LoginNavigator.swift
// CleanArchitecture
//
// Created by Tuan Truong on 1/16/19.
// Copyright © 2019 Framgia. All rights reserved.
//

protocol LoginNavigatorType {
    func toMain()
}

struct LoginNavigator: LoginNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController
    
    func toMain() {
        navigationController.showAutoCloseMessage(image: nil, title: nil, message: "Login success")
    }
}
