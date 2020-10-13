//
//  TestableObserver+.swift
//  CleanArchitectureTests
//
//  Created by Tuan Truong on 6/30/20.
//  Copyright © 2020 Sun Asterisk. All rights reserved.
//

import RxTest

extension TestableObserver {
    var lastEventElement: Element? {
        return self.events.last?.value.element
    }
    
    var firstEventElement: Element? {
        return self.events.first?.value.element
    }
}
