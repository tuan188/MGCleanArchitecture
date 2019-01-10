//
//  Repo.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/28/18.
//  Copyright © 2018 Framgia. All rights reserved.
//

import ObjectMapper

struct Repo {
    var id = 0
    var name: String
    var fullname: String
    var urlString: String
    var starCount: Int
    var folkCount: Int
    var avatarURLString: String
}

extension Repo {
    init() {
        self.init(
            id: 0,
            name: "",
            fullname: "",
            urlString: "",
            starCount: 0,
            folkCount: 0,
            avatarURLString: ""
        )
    }
}

extension Repo: Then, HasID, Hashable { }

extension Repo: Mappable {
    
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        fullname <- map["full_name"]
        urlString <- map["html_url"]
        starCount <- map["stargazers_count"]
        folkCount <- map["forks"]
        avatarURLString <- map["owner.avatar_url"]
    }
}
