//
//  RepoViewModel.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 9/5/18.
//  Copyright © 2018 Framgia. All rights reserved.
//

import UIKit

struct RepoViewModel {
    let repo: Repo
    
    var name: String {
        return repo.name
    }
    
    var url: URL? {
        return URL(string: repo.avatarURLString)
    }
}
