//
// ReposUseCase.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/28/18.
// Copyright © 2018 Framgia. All rights reserved.
//

protocol ReposUseCaseType {
    func getRepoList() -> Observable<PagingInfo<Repo>>
    func loadMoreRepoList(page: Int) -> Observable<PagingInfo<Repo>>
}

struct ReposUseCase: ReposUseCaseType {
    let repository: RepoRepositoryType
    
    func getRepoList() -> Observable<PagingInfo<Repo>> {
        return loadMoreRepoList(page: 1)
    }

    func loadMoreRepoList(page: Int) -> Observable<PagingInfo<Repo>> {
        return repository.getRepoList(page: page, perPage: 20)
    }
}

