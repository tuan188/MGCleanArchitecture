//
//  API+Product.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 2/27/20.
//  Copyright © 2020 Sun Asterisk. All rights reserved.
//

import ObjectMapper

extension API {
    func getProductList(_ input: GetProductListInput) -> Observable<[Product]> {
        return request(input)
    }
}

// MARK: - GetRepoList
extension API {
    final class GetProductListInput: APIInput {
        init() {
            super.init(urlString: API.Urls.getProductList,
                       parameters: nil,
                       method: .get,
                       requireAccessToken: true)
        }
    }
}
