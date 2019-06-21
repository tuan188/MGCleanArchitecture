//
//  AppSettings.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 1/14/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

import UIKit

final class AppSettings: NSObject {
    class var didInit: Bool {
        get {
            return UserDefaults.standard.bool(forKey: #function)
        }
        set {
            UserDefaults.standard.do {
                $0.set(newValue, forKey: #function)
                $0.synchronize()
            }
        }
    }
}
