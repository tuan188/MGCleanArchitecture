//
//  UserItemViewModel.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 1/14/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

struct UserItemViewModel {
    let name: String
    let gender: String
    let birthday: String
    
    init(user: User) {
        self.name = user.name
        self.gender = user.gender.name
        self.birthday = user.birthday.dateString()
    }
}
