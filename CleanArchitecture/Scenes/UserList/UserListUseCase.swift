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

struct UserListUseCase: UserListUseCaseType, GettingUsers {
    let userGatewayType: UserGatewayType
    
    func getUserList() -> Observable<[User]> {
        return getUsers()
    }
}
