//
//  RepoCarouselNavigator.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 15/12/2020.
//  Copyright © 2020 Sun Asterisk. All rights reserved.
//

import UIKit

protocol RepoCarouselNavigatorType {
    func toPageItemDetail(pageItem: PageItem)
}

struct RepoCarouselNavigator: RepoCarouselNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController

    func toPageItemDetail(pageItem: PageItem) {
        print(#function)
    }
}
