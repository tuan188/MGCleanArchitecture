//
//  ReposNavigator.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/28/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

protocol ReposNavigatorType {
    func toRepos()
    func toRepoDetail(repo: Repo)
    func toRepoCollection()
}

struct ReposNavigator: ReposNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController

    func toRepos() {
        let vc: ReposViewController = assembler.resolve(navigationController: navigationController)
        navigationController.pushViewController(vc, animated: true)
    }

    func toRepoDetail(repo: Repo) {
        print(#function)
    }
    
    func toRepoCollection() {
        let vc: RepoCollectionViewController = assembler.resolve(navigationController: navigationController)
        navigationController.pushViewController(vc, animated: true)
    }
}

