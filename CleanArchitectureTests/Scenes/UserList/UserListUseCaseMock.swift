//
//  UserListUseCaseMock.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 1/14/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

@testable import CleanArchitecture
import RxSwift

final class UserListUseCaseMock: UserListUseCaseType {

    // MARK: - getUserList

    var getUserListCalled = false

    var getUserListReturnValue: Observable<[User]> = {
        let items = [
            User().with { $0.id = "1" }
        ]
        
        return Observable.just(items)
    }()

    func getUserList() -> Observable<[User]> {
        getUserListCalled = true
        return getUserListReturnValue
    }
}
