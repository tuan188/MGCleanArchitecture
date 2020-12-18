//
//  RepoCarouselAssembler.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 15/12/2020.
//  Copyright © 2020 Sun Asterisk. All rights reserved.
//

import UIKit
import Reusable

protocol RepoCarouselAssembler {
    func resolve(navigationController: UINavigationController) -> RepoCarouselViewController
    func resolve(navigationController: UINavigationController) -> RepoCarouselViewModel
    func resolve(navigationController: UINavigationController) -> RepoCarouselNavigatorType
    func resolve() -> RepoCarouselUseCaseType
}

extension RepoCarouselAssembler {
    func resolve(navigationController: UINavigationController) -> RepoCarouselViewController {
        let vc = RepoCarouselViewController.instantiate()
        let vm: RepoCarouselViewModel = resolve(navigationController: navigationController)
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve(navigationController: UINavigationController) -> RepoCarouselViewModel {
        return RepoCarouselViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve()
        )
    }
}

extension RepoCarouselAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> RepoCarouselNavigatorType {
        return RepoCarouselNavigator(assembler: self, navigationController: navigationController)
    }
    
    func resolve() -> RepoCarouselUseCaseType {
        return RepoCarouselUseCase(repoGateway: resolve())
    }
}
