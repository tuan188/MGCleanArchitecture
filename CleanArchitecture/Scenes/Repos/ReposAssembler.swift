//
//  ReposAssembler.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 7/15/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

import Foundation

protocol ReposAssembler {
    func resolve(navigationController: UINavigationController) -> ReposViewController
    func resolve(navigationController: UINavigationController) -> RepoCollectionViewController
    func resolve(navigationController: UINavigationController) -> ReposViewModel
    func resolve(navigationController: UINavigationController) -> ReposNavigatorType
    func resolve() -> ReposUseCaseType
}

extension ReposAssembler {
    func resolve(navigationController: UINavigationController) -> ReposViewController {
        let vc = ReposViewController.instantiate()
        let vm: ReposViewModel = resolve(navigationController: navigationController)
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve(navigationController: UINavigationController) -> RepoCollectionViewController {
        let vc = RepoCollectionViewController.instantiate()
        let vm: ReposViewModel = resolve(navigationController: navigationController)
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve(navigationController: UINavigationController) -> ReposViewModel {
        return ReposViewModel(navigator: resolve(navigationController: navigationController),
                              useCase: resolve())
    }
}

extension ReposAssembler where Self: DefaultAssembler {
    func resolve() -> ReposUseCaseType {
        return ReposUseCase(repoGateway: resolve())
    }
    
    func resolve(navigationController: UINavigationController) -> ReposNavigatorType {
        return ReposNavigator(assembler: self, navigationController: navigationController)
    }
}
