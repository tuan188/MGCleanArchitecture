//
//  EditProductNavigatorMock.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/24/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

@testable import CleanArchitecture

final class EditProductNavigatorMock: EditProductNavigatorType {
    
    // MARK: - dismiss
    
    var dismissCalled = false
    
    func dismiss() {
        dismissCalled = true
    }
    
}

