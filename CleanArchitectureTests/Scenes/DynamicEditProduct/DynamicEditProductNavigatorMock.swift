//
// DynamicEditProductNavigatorMock.swift
// CleanArchitecture
//
// Created by Tuan Truong on 9/10/18.
// Copyright © 2018 Framgia. All rights reserved.
//

@testable import CleanArchitecture

final class DynamicEditProductNavigatorMock: DynamicEditProductNavigatorType {
    
    // MARK: - dismiss
    
    var dismissCalled = false
    
    func dismiss() {
        dismissCalled = true
    }
}
