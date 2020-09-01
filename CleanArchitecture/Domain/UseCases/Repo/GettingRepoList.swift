//
//  GettingRepoList.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/26/20.
//  Copyright © 2020 Sun Asterisk. All rights reserved.
//

import UIKit

protocol GettingRepoList {
    var repoGateway: RepoGatewayType { get }
}

extension GettingRepoList {
    func getRepoList(dto: GetPageDto) -> Observable<PagingInfo<Repo>> {
        return repoGateway.getRepoList(dto: dto)
    }
}
