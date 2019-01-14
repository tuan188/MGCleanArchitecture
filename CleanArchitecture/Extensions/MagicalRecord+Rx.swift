//
//  MagicalRecord+Rx.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 1/14/19.
//  Copyright © 2019 Framgia. All rights reserved.
//

import MagicalRecord
import RxSwift

extension Reactive where Base: MagicalRecord {
    static func save(block: @escaping (NSManagedObjectContext?) -> Void) -> Observable<Bool> {
        return Observable.create { observer in
            MagicalRecord.save(block, completion: { (changed, error) in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(changed)
                }
            })
            return Disposables.create()
        }
    }
    
    static func save(block: @escaping (NSManagedObjectContext?) -> Void) -> Observable<Void> {
        let observable: Observable<Bool> = MagicalRecord.rx.save(block: block)
        return observable.map { _ in () }
    }
}
