//
// AppUseCaseMock.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/4/18.
// Copyright © 2018 Framgia. All rights reserved.
//

@testable import CleanArchitecture
import RxSwift

final class AppUseCaseMock: AppUseCaseType {
    // MARK: - checkIfFirstRun
    
    var checkIfFirstRunCalled = false
    var checkIfFirstRunReturnValue: Bool = false
    
    func checkIfFirstRun() -> Bool {
        checkIfFirstRunCalled = true
        return checkIfFirstRunReturnValue
    }
    
    // MARK: - setDidInit
    
    var setDidInitCalled = false
    
    func setDidInit() {
        setDidInitCalled = true
    }
    
    // MARK: - initCoreData
    
    var initCoreDataCalled = false
    var initCoreDataReturnValue = Observable.just(())
    
    func initCoreData() -> Observable<Void> {
        initCoreDataCalled = true
        return initCoreDataReturnValue
    }
}
