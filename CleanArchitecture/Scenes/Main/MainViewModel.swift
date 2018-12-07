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
                Menu.allCases.map { MenuModel(menu: $0) }
            }
        
        let selectedMenu = input.selectMenuTrigger
            .withLatestFrom(menuList) { indexPath, menuList in
                menuList[indexPath.row]
            }
            .map { $0.menu }
            .do(onNext: { menu in
                switch menu {
                case .products:
                    self.navigator.toProducts()
                case .sectionedProducts:
                    self.navigator.toSectionedProducts()
                case .repos:
                    self.navigator.toRepos()
                case .repoCollection:
                    self.navigator.toRepoCollection()
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
    enum Menu: Int, CustomStringConvertible, CaseIterable {
        case products
        case sectionedProducts
        case repos
        case repoCollection
        
        var description: String {
            switch self {
            case .products:
                return "Product list"
            case .sectionedProducts:
                return "Sectioned product list"
            case .repos:
                return "Git repo list"
            case .repoCollection:
                return "Git repo collection"
            }
        }
    }
}
