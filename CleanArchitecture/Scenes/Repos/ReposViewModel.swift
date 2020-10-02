//
//  ReposViewModel.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/28/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

import MGArchitecture
import RxSwift
import RxCocoa

struct ReposViewModel {
    let navigator: ReposNavigatorType
    let useCase: ReposUseCaseType
}

// MARK: - ViewModel
extension ReposViewModel: ViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
        let reloadTrigger: Driver<Void>
        let loadMoreTrigger: Driver<Void>
        let selectRepoTrigger: Driver<IndexPath>
    }

    struct Output {
        @Property var error: Error?
        @Property var isLoading: Bool = false
        @Property var isReloading: Bool = false
        @Property var isLoadingMore: Bool = false
        @Property var repoList: [RepoItemViewModel] = []
        @Property var isEmpty: Bool = false
    }

    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        let getPageInput = GetPageInput(loadTrigger: input.loadTrigger,
                                        reloadTrigger: input.reloadTrigger,
                                        loadMoreTrigger: input.loadMoreTrigger,
                                        getItems: useCase.getRepoList(page:))
        
        let getPageResult = getPage(input: getPageInput)
        let (page, pagingError, isLoading, isReloading, isLoadingMore) = getPageResult.destructured

        let repoList = page
            .map { $0.items }
            
        repoList
            .map { $0.map(RepoItemViewModel.init) }
            .drive(output.$repoList)
            .disposed(by: disposeBag)

        select(trigger: input.selectRepoTrigger, items: repoList)
            .drive(onNext: navigator.toRepoDetail)
            .disposed(by: disposeBag)
        
        checkIfDataIsEmpty(trigger: Driver.merge(isLoading, isReloading), items: repoList)
            .drive(output.$isEmpty)
            .disposed(by: disposeBag)
        
        pagingError
            .drive(output.$error)
            .disposed(by: disposeBag)
        
        isLoading
            .drive(output.$isLoading)
            .disposed(by: disposeBag)
        
        isReloading
            .drive(output.$isReloading)
            .disposed(by: disposeBag)
        
        isLoadingMore
            .drive(output.$isLoadingMore)
            .disposed(by: disposeBag)

        return output
    }
}
