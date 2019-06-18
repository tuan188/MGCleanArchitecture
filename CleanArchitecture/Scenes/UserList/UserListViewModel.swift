//
// UserListViewModel.swift
// CleanArchitecture
//
// Created by Tuan Truong on 1/14/19.
// Copyright © 2019 Framgia. All rights reserved.
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
        let fetchItems: Driver<Void>
        let userList: Driver<[User]>
        let selectedUser: Driver<Void>
        let isEmpty: Driver<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let configOutput = configPagination(
            loadTrigger: input.loadTrigger,
            getItems: useCase.getUserList,
            reloadTrigger: input.reloadTrigger,
            reloadItems: useCase.getUserList,
            loadMoreTrigger: input.loadMoreTrigger,
            loadMoreItems: useCase.loadMoreUserList)
        
        let (page, fetchItems, loadError, isLoading, isReloading, isLoadingMore) = configOutput
        
        let userList = page
            .map { $0.items.map { $0 } }
            .asDriverOnErrorJustComplete()
        
        let selectedUser = input.selectUserTrigger
            .withLatestFrom(userList) {
                return ($0, $1)
            }
            .map { indexPath, userList in
                return userList[indexPath.row]
            }
            .do(onNext: { user in
                self.navigator.toUserDetail(user: user)
            })
            .mapToVoid()
        
        let isEmpty = checkIfDataIsEmpty(fetchItemsTrigger: fetchItems,
                                         loadTrigger: Driver.merge(isLoading, isReloading),
                                         items: userList)
        
        return Output(
            error: loadError,
            isLoading: isLoading,
            isReloading: isReloading,
            isLoadingMore: isLoadingMore,
            fetchItems: fetchItems,
            userList: userList,
            selectedUser: selectedUser,
            isEmpty: isEmpty
        )
    }
}
