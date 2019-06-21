//
//  UserListUseCase.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 1/14/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

protocol UserListUseCaseType {
    func getUserList() -> Observable<PagingInfo<User>>
    func loadMoreUserList(page: Int) -> Observable<PagingInfo<User>>
}

struct UserListUseCase: UserListUseCaseType {
    let userRepository: UserRepositoryType
    
    func getUserList() -> Observable<PagingInfo<User>> {
        return userRepository
            .getUsers()
            .map { PagingInfo(page: 1, items: $0) }
    }
    
    func loadMoreUserList(page: Int) -> Observable<PagingInfo<User>> {
        return Observable.empty()
    }
}
