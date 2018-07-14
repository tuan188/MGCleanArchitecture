//
//  APIInput.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/28/18.
//  Copyright © 2018 Framgia. All rights reserved.
//

import Alamofire

class APIInput: APIInputBase {
    override init(urlString: String, parameters: [String : Any]?,
                  requestType: HTTPMethod, requireAccessToken: Bool) {
        super.init(urlString: urlString,
                   parameters: parameters,
                   requestType: requestType,
                   requireAccessToken: requireAccessToken)
        self.headers = [
            "Content-Type": "application/json; charset=utf-8",
            "Accept": "application/json"
        ]
        self.user = nil
        self.password = nil
    }
}
