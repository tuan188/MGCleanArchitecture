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
extension UserListViewModel: ViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
        let reloadTrigger: Driver<Void>
        let selectUserTrigger: Driver<IndexPath>
    }
    
    struct Output {
        @Property var error: Error?
        @Property var isLoading = false
        @Property var isReloading = false
        @Property var userList = [UserViewModel]()
        @Property var isEmpty = false
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        let getListInput = GetListInput(loadTrigger: input.loadTrigger,
                                        reloadTrigger: input.reloadTrigger,
                                        getItems: useCase.getUserList)
        let getListResult = getList(input: getListInput)
        
        let (userList, error, isLoading, isReloading) = getListResult.destructured
        
        error
            .drive(output.$error)
            .disposed(by: disposeBag)
        
        isLoading
            .drive(output.$isLoading)
            .disposed(by: disposeBag)
        
        isReloading
            .drive(output.$isReloading)
            .disposed(by: disposeBag)
        
        userList
            .map { $0.map(UserViewModel.init) }
            .drive(output.$userList)
            .disposed(by: disposeBag)

        select(trigger: input.selectUserTrigger, items: userList)
            .do(onNext: navigator.toUserDetail)
            .drive()
            .disposed(by: disposeBag)
        
        checkIfDataIsEmpty(trigger: Driver.merge(isLoading, isReloading),
                           items: userList)
            .drive(output.$isEmpty)
            .disposed(by: disposeBag)
        
        return output
    }
}
