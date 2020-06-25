//
//  AddingUsers.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/25/20.
//  Copyright © 2020 Sun Asterisk. All rights reserved.
//

import UIKit

protocol AddingUsers {
    var userGatewayType: UserGatewayType { get }
}

extension AddingUsers {
    func add(_ users: [User]) -> Observable<Void> {
        return userGatewayType.add(users)
    }
}
