//
// UserListUseCaseMock.swift
// CleanArchitecture
//
// Created by Tuan Truong on 1/14/19.
// Copyright © 2019 Framgia. All rights reserved.
//

@testable import CleanArchitecture
import RxSwift

final class UserListUseCaseMock: UserListUseCaseType {

    // MARK: - getUserList

    var getUserListCalled = false

    var getUserListReturnValue: Observable<PagingInfo<User>> = {
        let items = [
            User().with { $0.id = "1" }
        ]
        let page = PagingInfo<User>(page: 1, items: items)
        return Observable.just(page)
    }()

    func getUserList() -> Observable<PagingInfo<User>> {
        getUserListCalled = true
        return getUserListReturnValue
    }

    // MARK: - loadMoreUserList

    var loadMoreUserListCalled = false
    
    var loadMoreUserListReturnValue: Observable<PagingInfo<User>> = {
        let items = [
            User().with { $0.id = "2" }
        ]
        let page = PagingInfo<User>(page: 2, items: items)
        return Observable.just(page)
    }()

    func loadMoreUserList(page: Int) -> Observable<PagingInfo<User>> {
        loadMoreUserListCalled = true
        return loadMoreUserListReturnValue
    }
}
