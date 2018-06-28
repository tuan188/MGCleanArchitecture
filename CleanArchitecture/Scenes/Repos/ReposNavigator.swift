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
    unowned let navigationController: UINavigationController

    func toRepos() {
        let vc = ReposViewController.instantiate()
        let vm = ReposViewModel(navigator: self, useCase: ReposUseCase())
        vc.bindViewModel(to: vm)
        navigationController.pushViewController(vc, animated: true)
    }

    func toRepoDetail(repo: Repo) {

    }
}

