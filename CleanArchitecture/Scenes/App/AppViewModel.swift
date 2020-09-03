//
//  AppViewModel.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/4/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

struct AppViewModel {
    let navigator: AppNavigatorType
    let useCase: AppUseCaseType
}

// MARK: - ViewModel
extension AppViewModel: ViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
    }
    
    struct Output {
        
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        input.loadTrigger
            .flatMapLatest {
                self.useCase.addUserData()
                    .asDriverOnErrorJustComplete()
            }
            .do(onNext: self.navigator.toMain)
            .drive()
            .disposed(by: disposeBag)
        
        return Output()
    }
}
