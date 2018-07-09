//
// ReposNavigatorMock.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/28/18.
// Copyright © 2018 Framgia. All rights reserved.
//

@testable import CleanArchitecture

final class ReposNavigatorMock: ReposNavigatorType {

    // MARK: - toRepos
    var toRepos_Called = false
    func toRepos() {
        toRepos_Called = true
    }

    // MARK: - toRepoDetail
    var toRepoDetail_Called = false
    func toRepoDetail(repo: Repo) {
        toRepoDetail_Called = true
    }
    
    // MARK: - toRepoCollection
    var toRepoCollection_Called = false
    
    func toRepoCollection() {
        toRepoCollection_Called = true
    }
}

