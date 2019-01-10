//
//  User.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 1/8/19.
//  Copyright © 2019 Framgia. All rights reserved.
//

enum Gender: Int {
    case unknown = 0
    case male = 1
    case female = 2
}

struct User {
    var id: Int
    var name: String
    var birthday: Date
}

extension User {
    init() {
        self.init(
            id: 0,
            name: "",
//            gender: Gender.unknown,
            birthday: Date()
        )
    }
}

extension User: Then { }
