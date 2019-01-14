//
//  RepositoriesAssembler.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 7/18/18.
//  Copyright © 2018 Framgia. All rights reserved.
//

import UIKit

protocol RepositoriesAssembler {
    func resolve() -> RepoRepositoryType
    func resolve() -> ProductRepositoryType
    func resolve() -> UserRepository
}

extension RepositoriesAssembler where Self: DefaultAssembler {
    func resolve() -> RepoRepositoryType {
        return RepoRepository()
    }
    
    func resolve() -> ProductRepositoryType {
        return ProductRepository()
    }
    
    func resolve() -> UserRepository {
        return UserRepository()
    }
    
}
