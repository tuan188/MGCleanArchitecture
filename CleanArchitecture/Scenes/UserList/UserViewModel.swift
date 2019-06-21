//
//  UserViewModel.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 1/14/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

struct UserViewModel {
    let user: User
    
    var name: String {
        return user.name
    }
        
    var gender: String {
        return user.gender.name
    }
        
    var birthday: String {
        return user.birthday.dateString()
    }
        
}
