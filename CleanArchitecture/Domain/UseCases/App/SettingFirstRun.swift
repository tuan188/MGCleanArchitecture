//
//  SettingFirstRun.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/25/20.
//  Copyright © 2020 Sun Asterisk. All rights reserved.
//

import UIKit

protocol SettingFirstRun {
    var appGateway: AppGatewayType { get }
}

extension SettingFirstRun {
    
    /// Save the status of the application that was first run
    func setFirstRun() {
        appGateway.setFirstRun()
    }
}
