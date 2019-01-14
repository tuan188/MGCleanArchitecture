//
// UserListNavigator.swift
// CleanArchitecture
//
// Created by Tuan Truong on 1/14/19.
// Copyright © 2019 Framgia. All rights reserved.
//

protocol UserListNavigatorType {
    func toUserDetail(user: User)
}

struct UserListNavigator: UserListNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController

    func toUserDetail(user: User) {

    }
}
