//
//  RepoCarouselUseCase.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 15/12/2020.
//  Copyright © 2020 Sun Asterisk. All rights reserved.
//

import RxSwift
import MGArchitecture
import Dto

protocol RepoCarouselUseCaseType {
    func getRepoList() -> Observable<[Repo]>
}

struct RepoCarouselUseCase: RepoCarouselUseCaseType, GettingRepoList {
    let repoGateway: RepoGatewayType
    
    func getRepoList() -> Observable<[Repo]> {
        return getRepoList(dto: GetPageDto(page: 1, perPage: 20, usingCache: true))
            .map {
                $0.items
            }
    }
}
