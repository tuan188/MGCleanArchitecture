//
//  APIError.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/28/18.
//  Copyright © 2018 Framgia. All rights reserved.
//

import UIKit

protocol APIError: LocalizedError {
    var statusCode: Int? { get }
}

extension APIError {
    var statusCode: Int? { return nil }
}

struct APIInvalidResponseError: APIError {
    var errorDescription: String? {
        return NSLocalizedString("api.invalidResponseError", comment: "")
    }
}

struct APIUnknownError: APIError {
    
    let statusCode: Int?
    
    var errorDescription: String? {
        return NSLocalizedString("api.unknownError", comment: "")
    }
}

