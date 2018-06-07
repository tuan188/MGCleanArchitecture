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
        let selectedMenu: Driver<Void>
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
        let selectedMenu = input.selectMenuTrigger
            .withLatestFrom(menuList) { indexPath, menuList in
                menuList[indexPath.row]
            }
            .map { $0.menu }
            .do(onNext: { menu in
                switch menu {
                case .login:
                    self.navigator.toLogin()
                case .products:
                    self.navigator.toProducts()
                case .sectionedProducts:
                    self.navigator.toSectionedProducts()
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
        case login
        case products
        case sectionedProducts
        
        var description: String {
            switch self {
            case .login:
                return "Login"
            case .products:
                return "Product list"
            case .sectionedProducts:
                return "Sectioned product list"
            }
        }
        
        static var all: [Menu] = [.login, .products, .sectionedProducts]
    }
}
