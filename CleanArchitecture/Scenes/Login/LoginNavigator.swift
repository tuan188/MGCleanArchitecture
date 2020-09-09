//
//  LoginNavigator.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 1/16/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

import UIKit

protocol LoginNavigatorType {
    func toMain()
}

struct LoginNavigator: LoginNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController
    
    func toMain() {
        navigationController.showAutoCloseMessage(image: nil, title: nil, message: "Login success")
    }
}
