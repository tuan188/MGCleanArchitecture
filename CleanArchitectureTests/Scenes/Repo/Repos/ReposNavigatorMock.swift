//
//  ReposNavigatorMock.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/28/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

@testable import CleanArchitecture

final class ReposNavigatorMock: ReposNavigatorType {

    // MARK: - toRepos
    
    var toReposCalled = false
    
    func toRepos() {
        toReposCalled = true
    }

    // MARK: - toRepoDetail
    
    var toRepoDetailCalled = false
    
    func toRepoDetail(repo: Repo) {
        toRepoDetailCalled = true
    }
    
    // MARK: - toRepoCollection
    
    var toRepoCollectionCalled = false
    
    func toRepoCollection() {
        toRepoCollectionCalled = true
    }
}

