//
//  RepoRepository.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 7/18/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

import UIKit

final class RepoRepository {
    func getRepoList(page: Int, perPage: Int, usingCache: Bool) -> Observable<PagingInfo<Repo>> {
        let input = API.GetRepoListInput(page: page, perPage: perPage)
        input.useCache = usingCache
        
        return API.shared.getRepoList(input)
            .map { $0.repos }
            .unwrap()
            .distinctUntilChanged { $0 == $1 }
            .map { repos in
                return PagingInfo<Repo>(page: page, items: repos)
            }
    }
}
