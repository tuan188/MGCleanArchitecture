//
//  MainViewModel.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/4/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

import RxSwift
import RxCocoa
import MGArchitecture
import UIKit

struct MainViewModel {
    let navigator: MainNavigatorType
    let useCase: MainUseCaseType
}

// MARK: - ViewModel
extension MainViewModel: ViewModel {
    struct Input {
        let load: Driver<Void>
        let selectMenu: Driver<IndexPath>
    }
    
    struct Output {
        @Property var menuSections = [MenuSection]()
    }

    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.load
            .map {
                self.menuSections()
            }
            .drive(output.$menuSections)
            .disposed(by: disposeBag)
        
        input.selectMenu
            .map { indexPath in
                output.menuSections[indexPath.section].menus[indexPath.row]
            }
            .drive(onNext: { menu in
                switch menu {
                case .products:
                    self.navigator.toProducts()
                case .sectionedProducts:
                    self.navigator.toSectionedProducts()
                case .sectionedProductCollection:
                    self.navigator.toSectionedProductCollection()
                case .repos:
                    self.navigator.toRepos()
                case .repoCollection:
                    self.navigator.toRepoCollection()
                case .repoCarousel:
                    self.navigator.toRepoCarousel()
                case .users:
                    self.navigator.toUsers()
                case .login:
                    self.navigator.toLogin()
                }
            })
            .disposed(by: disposeBag)
            
        return output
    }
    
    func menuSections() -> [MenuSection] {
        return [
            MenuSection(title: "Mock Data", menus: [.products, .sectionedProducts, .sectionedProductCollection]),
            MenuSection(title: "API", menus: [.repos, .repoCollection, .repoCarousel]),
            MenuSection(title: "Core Data", menus: [ .users ]),
            MenuSection(title: "", menus: [ .login ])
        ]
    }
}

extension MainViewModel {
    enum Menu: Int, CustomStringConvertible, CaseIterable {
        case products
        case sectionedProducts
        case sectionedProductCollection
        case repos
        case repoCollection
        case repoCarousel
        case users
        case login
        
        var description: String {
            switch self {
            case .products:
                return "Product list"
            case .sectionedProducts:
                return "Sectioned product list"
            case .sectionedProductCollection:
                return "Sectioned product collection"
            case .repos:
                return "Git repo list"
            case .repoCollection:
                return "Git repo collection"
            case .repoCarousel:
                return "Git repo carousel"
            case .users:
                return "User list"
            case .login:
                return "Login"
            }
        }
    }
    
    struct MenuSection {
        let title: String
        let menus: [Menu]
    }
}
