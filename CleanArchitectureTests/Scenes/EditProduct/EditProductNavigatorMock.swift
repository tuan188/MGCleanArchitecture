//
// EditProductNavigatorMock.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/24/18.
// Copyright © 2018 Framgia. All rights reserved.
//

@testable import CleanArchitecture

final class EditProductNavigatorMock: EditProductNavigatorType {
    
    // MARK: - dismiss
    var dismiss_Called = false
    func dismiss() {
        dismiss_Called = true
    }
    
}

