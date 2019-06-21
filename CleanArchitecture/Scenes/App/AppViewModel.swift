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

// MARK: - ViewModelType
extension AppViewModel: ViewModelType {
    struct Input {
        let loadTrigger: Driver<Void>
    }
    
    struct Output {
        let toMain: Driver<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let toMain = input.loadTrigger
            .map { _ in
                self.useCase.checkIfFirstRun()
            }
            .flatMapLatest { firstRun -> Driver<Bool> in
                if firstRun {
                    return self.useCase.initCoreData()
                        .asDriverOnErrorJustComplete()
                        .map { _ in firstRun }
                }
                return Driver.just(firstRun)
            }
            .do(onNext: { firstRun in
                if firstRun {
                    self.useCase.setDidInit()
                }
            })
            .mapToVoid()
            .do(onNext: self.navigator.toMain)
        
        return Output(toMain: toMain)
    }
}
