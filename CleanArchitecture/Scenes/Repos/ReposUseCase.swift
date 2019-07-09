//
//  ReposUseCase.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/28/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

protocol ReposUseCaseType {
    func getRepoList(page: Int) -> Observable<PagingInfo<Repo>>
}

struct ReposUseCase: ReposUseCaseType {
    let repository: RepoRepositoryType
    
    func getRepoList(page: Int) -> Observable<PagingInfo<Repo>> {
        return repository.getRepoList(page: page, perPage: 10, useCache: page == 1)
    }
}

