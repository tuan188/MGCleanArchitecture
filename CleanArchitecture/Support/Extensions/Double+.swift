//
//  Double+.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 9/6/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

extension Double {
    var currency: String {
        return String(format: "$%.02f", self)
    }
}
