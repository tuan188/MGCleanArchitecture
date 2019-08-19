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
        let loadMoreTrigger: Driver<Void>
        let selectUserTrigger: Driver<IndexPath>
    }
    
    struct Output {
        let error: Driver<Error>
        let isLoading: Driver<Bool>
        let isReloading: Driver<Bool>
        let isLoadingMore: Driver<Bool>
        let userList: Driver<[User]>
        let selectedUser: Driver<Void>
        let isEmpty: Driver<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let paginationResult = configPagination(
            loadTrigger: input.loadTrigger,
            reloadTrigger: input.reloadTrigger,
            loadMoreTrigger: input.loadMoreTrigger,
            getItems: useCase.getUserList)
        
        let (page, error, isLoading, isReloading, isLoadingMore) = paginationResult.destructured
        
        let userList = page
            .map { $0.items.map { $0 } }
        
        let selectedUser = select(trigger: input.selectUserTrigger, items: userList)
            .do(onNext: navigator.toUserDetail)
            .mapToVoid()
        
        let isEmpty = checkIfDataIsEmpty(trigger: Driver.merge(isLoading, isReloading),
                                         items: userList)
        
        return Output(
            error: error,
            isLoading: isLoading,
            isReloading: isReloading,
            isLoadingMore: isLoadingMore,
            userList: userList,
            selectedUser: selectedUser,
            isEmpty: isEmpty
        )
    }
}
