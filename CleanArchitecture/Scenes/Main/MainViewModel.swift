//
// MainViewModel.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/4/18.
// Copyright © 2018 Framgia. All rights reserved.
//

struct MainViewModel {
    let navigator: MainNavigatorType
    let useCase: MainUseCaseType
}

// MARK: - ViewModelType
extension MainViewModel: ViewModelType {
    struct Input {
        let loadTrigger: Driver<Void>
        let selectMenuTrigger: Driver<IndexPath>
    }
    
    struct Output {
        let menuList: Driver<[MenuModel]>
        let selectedMenu: Driver<Void>
    }
    
    struct MenuModel {
        let menu: Menu
    }

    func transform(_ input: Input) -> Output {
        let menuList = input.loadTrigger
            .map {
                Menu.all.map { MenuModel(menu: $0) }
            }
        let selectedMenu = input.selectMenuTrigger
            .withLatestFrom(menuList) { indexPath, menuList in
                menuList[indexPath.row]
            }
            .map { $0.menu }
            .do(onNext: { menu in
                switch menu {
                case .repos:
                    self.navigator.toRepos()
                }
            })
            .mapToVoid()
        return Output(
            menuList: menuList,
            selectedMenu: selectedMenu
        )
    }
}

extension MainViewModel {
    enum Menu: Int, CustomStringConvertible {
        case repos
        
        var description: String {
            switch self {
            case .repos:
                return "Git repo list"
            }
        }
        
        static var all: [Menu] = [.repos]
    }
}
