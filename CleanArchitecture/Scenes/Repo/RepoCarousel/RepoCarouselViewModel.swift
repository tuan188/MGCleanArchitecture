//
//  RepoCarouselViewModel.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 15/12/2020.
//  Copyright © 2020 Sun Asterisk. All rights reserved.
//

import MGArchitecture
import RxSwift
import RxCocoa
import UIKit

struct RepoCarouselViewModel {
    let navigator: RepoCarouselNavigatorType
    let useCase: RepoCarouselUseCaseType
}

// MARK: - ViewModel
extension RepoCarouselViewModel: ViewModel {
    struct Input {
        let load: Driver<Void>
        let reload: Driver<Void>
        let selectRepo: Driver<IndexPath>
    }

    struct Output {
        @Property var error: Error?
        @Property var isLoading = false
        @Property var isReloading = false
        @Property var sections = [PageSectionViewModel]()
        @Property var isEmpty = false
    }

    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        let getListInput = GetListInput(loadTrigger: input.load,
                                        reloadTrigger: input.reload,
                                        getItems: useCase.getRepoList)
        
        let getListResult = getList(input: getListInput)
        let (repoList, error, isLoading, isReloading) = getListResult.destructured
            
        repoList
            .map { repos -> [PageSectionViewModel] in
                if repos.count == 20 {
                    return [
                        PageSectionViewModel(
                            index: 0,
                            type: .carousel,
                            items: (0...6).map { index -> PageItemViewModel in
                                return PageItemViewModel(pageItem: repos[index])
                            }
                        ),
                        PageSectionViewModel(
                            index: 0,
                            type: .list,
                            items: (7...14).map { index -> PageItemViewModel in
                                return PageItemViewModel(pageItem: repos[index])
                            }
                        )
                        ,
                        PageSectionViewModel(
                            index: 0,
                            type: .card,
                            items: (15...19).map { index -> PageItemViewModel in
                                return PageItemViewModel(pageItem: repos[index])
                            }
                        )
                    ]
                }
                return [
                    PageSectionViewModel(index: 0, type: .card, items: repos.map(PageItemViewModel.init))
                ]
            }
            .drive(output.$sections)
            .disposed(by: disposeBag)

        select(trigger: input.selectRepo, items: repoList)
            .drive(onNext: navigator.toPageItemDetail)
            .disposed(by: disposeBag)
        
        checkIfDataIsEmpty(trigger: Driver.merge(isLoading, isReloading), items: repoList)
            .drive(output.$isEmpty)
            .disposed(by: disposeBag)
        
        error
            .drive(output.$error)
            .disposed(by: disposeBag)
        
        isLoading
            .drive(output.$isLoading)
            .disposed(by: disposeBag)
        
        isReloading
            .drive(output.$isReloading)
            .disposed(by: disposeBag)
        
        return output
    }
}
