//
//  AppUseCaseMock.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/4/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

@testable import CleanArchitecture
import RxSwift

final class AppUseCaseMock: AppUseCaseType {

    // MARK: - addUserData

    var addUserDataCalled = false
    var addUserDataReturnValue = Observable.just(())

    func addUserData() -> Observable<Void> {
        addUserDataCalled = true
        return addUserDataReturnValue
    }
}
