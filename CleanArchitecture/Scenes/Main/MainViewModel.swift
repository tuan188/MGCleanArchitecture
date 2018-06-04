//
// MainViewModel.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/4/18.
// Copyright © 2018 Framgia. All rights reserved.
//

struct MainViewModel: ViewModelType {

    struct Input {

    }

    struct Output {

    }

    let navigator: MainNavigatorType
    let useCase: MainUseCaseType

    func transform(_ input: Input) -> Output {
        return Output()
    }
}
