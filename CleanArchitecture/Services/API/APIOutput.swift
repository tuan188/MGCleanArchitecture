//
//  APIOutput.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/28/18.
//  Copyright © 2018 Framgia. All rights reserved.
//

import ObjectMapper

class APIOutput: APIOutputBase {
    var message: String?
    
    override func mapping(map: Map) {
        message <- map["message"]
    }
}
