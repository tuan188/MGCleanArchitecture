//
// AppViewModel.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/4/18.
// Copyright © 2018 Framgia. All rights reserved.
//

struct AppViewModel: ViewModelType {

    struct Input {
        let loadTrigger: Driver<Void>
    }

    struct Output {
        let toMain: Driver<Void>
    }

    let navigator: AppNavigatorType
    let useCase: AppUseCaseType

    func transform(_ input: Input) -> Output {
        let toMain = input.loadTrigger
            .do(onNext: self.navigator.toMain)
        return Output(toMain: toMain)
    }
}
