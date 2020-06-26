//
//  GatewaysAssembler.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/24/20.
//  Copyright © 2020 Sun Asterisk. All rights reserved.
//

import UIKit

protocol GatewaysAssembler {
    func resolve() -> UserGatewayType
    func resolve() -> AppGatewayType
    func resolve() -> RepoGatewayType
}

extension GatewaysAssembler where Self: DefaultAssembler {
    func resolve() -> UserGatewayType {
        return UserGateway()
    }
    
    func resolve() -> AppGatewayType {
        return AppGateway()
    }
    
    func resolve() -> RepoGatewayType {
        return RepoGateway()
    }
}
