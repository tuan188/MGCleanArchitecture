//
//  CheckingFirstRun.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/25/20.
//  Copyright © 2020 Sun Asterisk. All rights reserved.
//

import UIKit

protocol CheckingFirstRun {
    var appGateway: AppGatewayType { get }
}

extension CheckingFirstRun {
    
    /// Check if this is the first time the application is running
    /// - Returns: true if this is the first time
    func checkFirstRun() -> Bool {
        return appGateway.checkFirstRun()
    }
}
