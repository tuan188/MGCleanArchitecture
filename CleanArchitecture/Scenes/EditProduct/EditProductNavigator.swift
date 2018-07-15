//
// EditProductNavigator.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/24/18.
// Copyright © 2018 Framgia. All rights reserved.
//

protocol EditProductNavigatorType {
    func dismiss()
}

struct EditProductNavigator: EditProductNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController
    
    func dismiss() {
        navigationController.dismiss(animated: true, completion: nil)
    }
}
