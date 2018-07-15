//
// ProductDetailNavigator.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/22/18.
// Copyright © 2018 Framgia. All rights reserved.
//

protocol ProductDetailNavigatorType {
    
}

struct ProductDetailNavigator: ProductDetailNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController
}
