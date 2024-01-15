//
//  UserGateway.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/24/20.
//  Copyright © 2020 Sun Asterisk. All rights reserved.
//

import UIKit
import RxSwift

protocol UserGatewayType {
    func getUsers() -> Observable<[User]>
    func add(dto: AddUserDto) -> Observable<Void>
}

struct UserGateway: UserGatewayType {
    func getUsers() -> Observable<[User]> {
        .empty()
    }
    
    func add(dto: AddUserDto) -> Observable<Void> {
        .empty()
    }
}
