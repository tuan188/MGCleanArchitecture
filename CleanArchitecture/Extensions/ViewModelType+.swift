//
//  ViewModelType+.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 1/3/19.
//  Copyright © 2019 Framgia. All rights reserved.
//

extension ViewModelType {
    func checkIfDataIsEmpty<T: Collection>(fetchItemsTrigger: Driver<Void>,
                                           loadTrigger: Driver<Bool>,
                                           items: Driver<T>) -> Driver<Bool> {
        return Driver.combineLatest(fetchItemsTrigger, loadTrigger)
            .map { $0.1 }
            .withLatestFrom(items) { ($0, $1.isEmpty) }
            .map { loading, isEmpty -> Bool in
                if loading { return false }
                return isEmpty
            }
    }
}
