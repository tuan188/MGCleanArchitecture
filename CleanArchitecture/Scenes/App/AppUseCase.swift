//
//  AppUseCase.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/4/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

import RxSwift

protocol AppUseCaseType {
    func addUserData() -> Observable<Void>
}

struct AppUseCase: AppUseCaseType, SettingUpUserData {
    let appGateway: AppGatewayType
    let userGateway: UserGatewayType
}
