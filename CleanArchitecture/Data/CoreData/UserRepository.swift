//
//  UserRepository.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 1/14/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

import MagicalRecord

struct UserRepository {
    func getUsers() -> Observable<[User]> {
        return all()
    }
    
    func add(_ users: [User]) -> Observable<Void> {
        return addAll(users)
    }
}

extension UserRepository: CoreDataRepository {
    static func map(from item: User, to entity: CDUser) {
        entity.id = item.id
        entity.name = item.name
        entity.gender = Int64(item.gender.rawValue)
        entity.birthday = item.birthday
    }
    
    static func item(from entity: CDUser) -> User? {
        guard let id = entity.id else { return nil }
        return User(
            id: id,
            name: entity.name ?? "",
            gender: Gender(rawValue: Int(entity.gender)) ?? Gender.unknown,
            birthday: entity.birthday ?? Date()
        )
    }
}
