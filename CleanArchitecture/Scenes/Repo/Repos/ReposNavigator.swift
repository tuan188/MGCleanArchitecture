//
//  ReposNavigator.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/28/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

import UIKit

protocol ReposNavigatorType {
    func toRepoDetail(repo: Repo)
}

struct ReposNavigator: ReposNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController

    func toRepoDetail(repo: Repo) {
        print(#function)
    }
}

