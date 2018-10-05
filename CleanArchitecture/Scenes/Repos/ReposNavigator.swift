//
// ReposNavigator.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/28/18.
// Copyright © 2018 Framgia. All rights reserved.
//

protocol ReposNavigatorType {
    func toRepos()
    func toRepoDetail(repo: Repo)
}

struct ReposNavigator: ReposNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController

    func toRepos() {
        let vc: ReposViewController = assembler.resolve(navigationController: navigationController)
        navigationController.pushViewController(vc, animated: true)
    }

    func toRepoDetail(repo: Repo) {

    }
}

