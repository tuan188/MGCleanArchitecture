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
        let menuSections: Driver<[MenuSection]>
        let selectedMenu: Driver<Void>
    }

    func transform(_ input: Input) -> Output {
        let menuSections = input.loadTrigger
            .map {
                self.menuSections()
            }
        
        let selectedMenu = input.selectMenuTrigger
            .withLatestFrom(menuSections) { indexPath, menuSections in
                menuSections[indexPath.section].menus[indexPath.row]
            }
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
            menuSections: menuSections,
            selectedMenu: selectedMenu
        )
    }
    
    func menuSections() -> [MenuSection] {
        return [
            MenuSection(title: "Mock Data", menus: [.products, .sectionedProducts]),
            MenuSection(title: "API", menus: [.repos, .repoCollection])
        ]
    }
}

extension MainViewModel {
    enum Menu: Int, CustomStringConvertible, CaseIterable {
        case products = 0
        case sectionedProducts = 1
        case repos = 2
        case repoCollection = 3
        
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
    
    struct MenuSection {
        let title: String
        let menus: [Menu]
    }
}
