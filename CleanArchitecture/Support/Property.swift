//
//  Property.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 8/25/20.
//  Copyright © 2020 Sun Asterisk. All rights reserved.
//

import UIKit
import RxSwift

@propertyWrapper
public struct Property<Value> {
    
    private var subject: BehaviorRelay<Value>
   
    public var wrappedValue: Value {
        get {
            return subject.value
        }
        set {
            subject.accept(newValue)
        }
    }
    
    public var projectedValue: BehaviorRelay<Value> {
        return self.subject
    }
    
    public init(wrappedValue: Value) {
        subject = BehaviorRelay(value: wrappedValue)
    }
}
