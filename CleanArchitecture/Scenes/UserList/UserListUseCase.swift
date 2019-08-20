//
//  UserListUseCase.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 1/14/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

protocol UserListUseCaseType {
    func getUserList() -> Observable<[User]>
}

struct UserListUseCase: UserListUseCaseType {
    let userRepository: UserRepositoryType
    
    func getUserList() ->Observable<[User]> {
        return userRepository
            .getUsers()
    }
}
