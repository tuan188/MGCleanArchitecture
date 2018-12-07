//
// AppNavigatorMock.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/4/18.
// Copyright © 2018 Framgia. All rights reserved.
//

@testable import CleanArchitecture

final class AppNavigatorMock: AppNavigatorType {
    
    // MARK: - toMain
    
    var toMain_Called = false
    
    func toMain() {
        toMain_Called = true
    }
}
