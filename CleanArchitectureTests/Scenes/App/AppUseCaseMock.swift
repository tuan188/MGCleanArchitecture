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

    // MARK: - checkFirstRun

    var checkFirstRunCalled = false
    var checkFirstRunReturnValue = false

    func checkFirstRun() -> Bool {
        checkFirstRunCalled = true
        return checkFirstRunReturnValue
    }

    // MARK: - setFirstRun

    var setFirstRunCalled = false

    func setFirstRun() {
        setFirstRunCalled = true
    }

    // MARK: - initCoreData

    var initCoreDataCalled = false
    var initCoreDataReturnValue = Observable.just(())

    func initCoreData() -> Observable<Void> {
        initCoreDataCalled = true
        return initCoreDataReturnValue
    }
}
