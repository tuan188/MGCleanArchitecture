//
//  RepoGateway.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/26/20.
//  Copyright © 2020 Sun Asterisk. All rights reserved.
//

import UIKit

protocol RepoGatewayType {
    func getRepoList(page: Int, perPage: Int, usingCache: Bool) -> Observable<PagingInfo<Repo>>
}

struct RepoGateway: RepoGatewayType {
    private let repoRepository = RepoRepository()
    
    func getRepoList(page: Int, perPage: Int, usingCache: Bool) -> Observable<PagingInfo<Repo>> {
        return repoRepository.getRepoList(page: page, perPage: perPage, usingCache: usingCache)
    }
}
