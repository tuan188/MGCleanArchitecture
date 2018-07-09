//
// MainNavigatorMock.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/4/18.
// Copyright © 2018 Framgia. All rights reserved.
//

@testable import CleanArchitecture

final class MainNavigatorMock: MainNavigatorType {
    
    // MARK: - toLogin
    var toLogin_Called = false
    func toLogin() {
        toLogin_Called = true
    }
    
    // MARK: - toProducts
    var toProducts_Called = false
    func toProducts() {
        toProducts_Called = true
    }
    
    // MARK: - toSectionedProducts
    var toSectionedProducts_Called = false
    func toSectionedProducts() {
        toSectionedProducts_Called = true
    }
    
    // MARK: - toRepos
    var toRepos_Called = false
    func toRepos() {
        toRepos_Called = true
    }
    
    // MARK: - toRepoCollection
    var toRepoCollection_Called = false
    
    func toRepoCollection() {
        toRepoCollection_Called = true
    }
    
}
