//
//  AppUseCase.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/4/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

protocol AppUseCaseType {
    func checkIfFirstRun() -> Bool
    func setDidInit()
    func initCoreData() -> Observable<Void>
}

struct AppUseCase: AppUseCaseType {
    let userRepository: UserRepositoryType
    
    func checkIfFirstRun() -> Bool {
        return !AppSettings.didInit
    }
    
    func setDidInit() {
        AppSettings.didInit = true
    }
    
    func initCoreData() -> Observable<Void> {
        let users = [
            User(id: UUID().uuidString,
                 name: "John Appleseed",
                 gender: .male,
                 birthday: Date.date(day: 22, month: 6, year: 1_980) ?? Date()),
            User(id: UUID().uuidString,
                 name: "Kate Bell",
                 gender: .female,
                 birthday: Date.date(day: 20, month: 1, year: 1_978) ?? Date()),
            User(id: UUID().uuidString,
                 name: "Anna Haro",
                 gender: .female,
                 birthday: Date.date(day: 29, month: 8, year: 1_985) ?? Date())
        ]
        return userRepository.add(users)
    }
}
