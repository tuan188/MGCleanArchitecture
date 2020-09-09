//
//  DynamicEditProductNavigator.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 9/10/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

import UIKit

protocol DynamicEditProductNavigatorType {
    func dismiss()
}

struct DynamicEditProductNavigator: DynamicEditProductNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController
    
    func dismiss() {
        navigationController.dismiss(animated: true, completion: nil)
    }
}
