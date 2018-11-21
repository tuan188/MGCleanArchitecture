//
// ReposUseCaseMock.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/28/18.
// Copyright © 2018 Framgia. All rights reserved.
//

@testable import CleanArchitecture
import RxSwift

final class ReposUseCaseMock: ReposUseCaseType {

    // MARK: - getRepoList
    var getRepoList_Called = false
    var getRepoList_ReturnValue: Observable<PagingInfo<Repo>> = {
        let items = [
            Repo().with { $0.id = 1 }
        ]
        let page = PagingInfo<Repo>(page: 1, items: items)
        return Observable.just(page)
    }()
    func getRepoList() -> Observable<PagingInfo<Repo>> {
        getRepoList_Called = true
        return getRepoList_ReturnValue
    }

    // MARK: - loadMoreRepoList
    var loadMoreRepoList_Called = false
    var loadMoreRepoList_ReturnValue: Observable<PagingInfo<Repo>> = {
        let items = [
            Repo().with { $0.id = 2 }
        ]
        let page = PagingInfo<Repo>(page: 2, items: items)
        return Observable.just(page)
    }()
    func loadMoreRepoList(page: Int) -> Observable<PagingInfo<Repo>> {
        loadMoreRepoList_Called = true
        return loadMoreRepoList_ReturnValue
    }
}
