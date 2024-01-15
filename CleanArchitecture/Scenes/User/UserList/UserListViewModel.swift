//
//  UserListViewModel.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 1/14/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

import MGArchitecture
import RxSwift
import RxCocoa
import UIKit

struct UserListViewModel {
    let navigator: UserListNavigatorType
    let useCase: UserListUseCaseType
}

// MARK: - ViewModel
extension UserListViewModel: ViewModel {
    struct Input {
        let load: Driver<Void>
        let reload: Driver<Void>
        let selectUser: Driver<IndexPath>
    }
    
    struct Output {
        @Property var error: Error?
        @Property var isLoading = false
        @Property var isReloading = false
        @Property var userList = [UserItemViewModel]()
        @Property var isEmpty = false
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        let getListInput = GetListInput(loadTrigger: input.load,
                                        reloadTrigger: input.reload,
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
            .map { $0.map(UserItemViewModel.init) }
            .drive(output.$userList)
            .disposed(by: disposeBag)

        select(trigger: input.selectUser, items: userList)
            .drive(onNext: navigator.toUserDetail)
            .disposed(by: disposeBag)
        
        checkIfDataIsEmpty(trigger: Driver.merge(isLoading, isReloading),
                           items: userList)
            .drive(output.$isEmpty)
            .disposed(by: disposeBag)
        
        return output
    }
}
