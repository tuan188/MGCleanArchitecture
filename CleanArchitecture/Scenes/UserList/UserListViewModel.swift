//
//  UserListViewModel.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 1/14/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

struct UserListViewModel {
    let navigator: UserListNavigatorType
    let useCase: UserListUseCaseType
}

// MARK: - ViewModelType
extension UserListViewModel: ViewModelType {
    struct Input {
        let loadTrigger: Driver<Void>
        let reloadTrigger: Driver<Void>
        let selectUserTrigger: Driver<IndexPath>
    }
    
    struct Output {
        let error: Driver<Error>
        let isLoading: Driver<Bool>
        let isReloading: Driver<Bool>
        let userList: Driver<[User]>
        let selectedUser: Driver<Void>
        let isEmpty: Driver<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let getListResult = getList(
            loadTrigger: input.loadTrigger,
            reloadTrigger: input.reloadTrigger,
            getItems: useCase.getUserList)
        
        let (userList, error, isLoading, isReloading) = getListResult.destructured

        let selectedUser = select(trigger: input.selectUserTrigger, items: userList)
            .do(onNext: navigator.toUserDetail)
            .mapToVoid()
        
        let isEmpty = checkIfDataIsEmpty(trigger: Driver.merge(isLoading, isReloading),
                                         items: userList)
        
        return Output(
            error: error,
            isLoading: isLoading,
            isReloading: isReloading,
            userList: userList,
            selectedUser: selectedUser,
            isEmpty: isEmpty
        )
    }
}
