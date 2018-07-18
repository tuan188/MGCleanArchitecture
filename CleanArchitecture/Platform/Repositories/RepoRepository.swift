//
//  RepoRepository.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 7/18/18.
//  Copyright © 2018 Framgia. All rights reserved.
//

import UIKit

protocol RepoRepositoryType {
    func getRepoList(page: Int, perPage: Int) -> Observable<PagingInfo<Repo>>
}

final class RepoRepository: RepoRepositoryType {
    func getRepoList(page: Int, perPage: Int) -> Observable<PagingInfo<Repo>> {
        let input = API.GetRepoListInput(page: page, perPage: perPage)
        let output: Observable<API.GetRepoListOutput> = API.shared.request(input)
        return output.map { output in
            guard let repos = output.repos else {
                throw APIInvalidResponseError()
            }
            return PagingInfo<Repo>(page: page, items: OrderedSet<Repo>(sequence: repos))
        }
    }
}
