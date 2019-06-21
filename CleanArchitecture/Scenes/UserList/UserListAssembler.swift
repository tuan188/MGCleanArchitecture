//
//  UserListAssembler.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 1/14/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

import UIKit

protocol UserListAssembler {
    func resolve(navigationController: UINavigationController) -> UserListViewController
    func resolve(navigationController: UINavigationController) -> UserListViewModel
    func resolve(navigationController: UINavigationController) -> UserListNavigatorType
    func resolve() -> UserListUseCaseType
}

extension UserListAssembler {
    func resolve(navigationController: UINavigationController) -> UserListViewController {
        let vc = UserListViewController.instantiate()
        let vm: UserListViewModel = resolve(navigationController: navigationController)
        vc.bindViewModel(to: vm)
        return vc
    }

    func resolve(navigationController: UINavigationController) -> UserListViewModel {
        return UserListViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve()
        )
    }
}

extension UserListAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> UserListNavigatorType {
        return UserListNavigator(assembler: self, navigationController: navigationController)
    }

    func resolve() -> UserListUseCaseType {
        return UserListUseCase(userRepository: resolve())
    }
}
