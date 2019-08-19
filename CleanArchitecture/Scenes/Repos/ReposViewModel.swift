//
//  ReposViewModel.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/28/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

struct ReposViewModel {
    let navigator: ReposNavigatorType
    let useCase: ReposUseCaseType
}

// MARK: - ViewModelType
extension ReposViewModel: ViewModelType {
    struct Input {
        let loadTrigger: Driver<Void>
        let reloadTrigger: Driver<Void>
        let loadMoreTrigger: Driver<Void>
        let selectRepoTrigger: Driver<IndexPath>
    }

    struct Output {
        let error: Driver<Error>
        let isLoading: Driver<Bool>
        let isReloading: Driver<Bool>
        let isLoadingMore: Driver<Bool>
        let repoList: Driver<[Repo]>
        let selectedRepo: Driver<Void>
        let isEmpty: Driver<Bool>
    }

    func transform(_ input: Input) -> Output {
        let paginationResult = configPagination(
            loadTrigger: input.loadTrigger,
            reloadTrigger: input.reloadTrigger,
            loadMoreTrigger: input.loadMoreTrigger,
            getItems: useCase.getRepoList(page:))
        
        let (page, paginationError, isLoading, isReloading, isLoadingMore) = paginationResult.destructured

        let repoList = page
            .map { $0.items }

        let selectedRepo = select(trigger: input.selectRepoTrigger, items: repoList)
            .do(onNext: navigator.toRepoDetail)
            .mapToVoid()
        
        let isEmpty = checkIfDataIsEmpty(trigger: Driver.merge(isLoading, isReloading),
                                         items: repoList)

        return Output(
            error: paginationError,
            isLoading: isLoading,
            isReloading: isReloading,
            isLoadingMore: isLoadingMore,
            repoList: repoList,
            selectedRepo: selectedRepo,
            isEmpty: isEmpty
        )
    }
}
