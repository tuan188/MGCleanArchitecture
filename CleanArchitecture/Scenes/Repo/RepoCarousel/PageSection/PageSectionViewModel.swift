//
//  PageSectionViewModel.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 17/12/2020.
//  Copyright © 2020 Sun Asterisk. All rights reserved.
//

import Foundation

struct PageSectionViewModel {
    var index: Int
    var type: SectionType
    var items: [PageItemViewModel]
}
