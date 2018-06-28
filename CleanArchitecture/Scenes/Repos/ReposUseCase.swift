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
    func getRepoList() -> Observable<PagingInfo<Repo>> {
        return loadMoreRepoList(page: 1)
    }

    func loadMoreRepoList(page: Int) -> Observable<PagingInfo<Repo>> {
        let input = API.GetRepoListInput(page: page)
        return API.shared.getRepoList(input)
            .map { output in
                guard let repos = output.repos else {
                    throw APIInvalidResponseError()
                }
                return PagingInfo<Repo>(page: page, items: OrderedSet<Repo>(sequence: repos))
            }
    }
}

