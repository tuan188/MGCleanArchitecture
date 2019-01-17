//
//  UserRepository.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 1/14/19.
//  Copyright © 2019 Framgia. All rights reserved.
//

import MagicalRecord

protocol UserRepositoryType {
    func getUsers() -> Observable<[User]>
    func add(_ users: [User]) -> Observable<Void>
}

struct UserRepository: UserRepositoryType {
    func getUsers() -> Observable<[User]> {
        return all()
    }
    
    func add(_ users: [User]) -> Observable<Void> {
        return addAll(users)
    }
}

extension UserRepository: CoreDataRepository {
    static func map(from item: User, to entity: UserEntity) {
        entity.id = item.id
        entity.name = item.name
        entity.gender = Int64(item.gender.rawValue)
        entity.birthday = item.birthday
    }
    
    static func item(from entity: UserEntity) -> User? {
        guard let id = entity.id else { return nil }
        return User(
            id: id,
            name: entity.name ?? "",
            gender: Gender(rawValue: Int(entity.gender)) ?? Gender.unknown,
            birthday: entity.birthday ?? Date()
        )
    }
}
