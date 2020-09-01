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

struct ReposUseCase: ReposUseCaseType, GettingRepoList {
    let repoGateway: RepoGatewayType
    
    func getRepoList(page: Int) -> Observable<PagingInfo<Repo>> {
        return getRepoList(dto: GetPageDto(page: page, perPage: 10, usingCache: true))
    }
}

