//
//  UserListNavigatorMock.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 1/14/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

@testable import CleanArchitecture

final class UserListNavigatorMock: UserListNavigatorType {
    
    // MARK: - toUserDetail

    var toUserDetailCalled = false

    func toUserDetail(user: User) {
        toUserDetailCalled = true
    }
}