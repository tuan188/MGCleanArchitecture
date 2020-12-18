//
//  PageSection.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 16/12/2020.
//  Copyright © 2020 Sun Asterisk. All rights reserved.
//

import Foundation

enum SectionType {
    case list
    case card
    case carousel
}

struct PageSection {
    var type: SectionType
    var items: [PageItem]
}

