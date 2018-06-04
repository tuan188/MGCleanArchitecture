//
// MainViewModel.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/4/18.
// Copyright © 2018 Framgia. All rights reserved.
//

struct MainViewModel: ViewModelType {

    struct Input {
        let loadTrigger: Driver<Void>
        let selectMenuTrigger: Driver<IndexPath>
    }
    
    struct Output {
        let menuList: Driver<[MenuModel]>
        let selectedMenu: Driver<MenuModel>
    }
    
    struct MenuModel {
        let menu: Menu
    }

    let navigator: MainNavigatorType
    let useCase: MainUseCaseType

    func transform(_ input: Input) -> Output {
        let menuList = input.loadTrigger
            .map {
                Menu.all.map { MenuModel(menu: $0) }
            }
        return Output(
            menuList: menuList,
            selectedMenu: Driver.empty()
        )
    }
}

extension MainViewModel {
    enum Menu: Int, CustomStringConvertible {
        case login
        case products
        
        var description: String {
            switch self {
            case .login:
                return "Login"
            case .products:
                return "Product list"
            }
        }
        
        static var all: [Menu] = [.login, .products]
    }
}
