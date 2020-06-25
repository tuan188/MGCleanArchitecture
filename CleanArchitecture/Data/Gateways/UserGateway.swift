//
//  UserGateway.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/24/20.
//  Copyright © 2020 Sun Asterisk. All rights reserved.
//

import UIKit

protocol UserGatewayType {
    func getUsers() -> Observable<[User]>
    func add(_ users: [User]) -> Observable<Void>
}

struct UserGateway: UserGatewayType {
    private let userRepository = UserRepository()
    
    func getUsers() -> Observable<[User]> {
        return userRepository.getUsers()
    }
    
    func add(_ users: [User]) -> Observable<Void> {
        return userRepository.add(users)
    }
}
