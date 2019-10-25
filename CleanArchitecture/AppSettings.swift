//
//  AppSettings.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 1/14/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

import UIKit

enum AppSettings {
    
    @Storage(key: "didInit", defaultValue: false)
    static var didInit: Bool // swiftlint:disable:this let_var_whitespace
}
