//
//  ListSectionLayout.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 16/12/2020.
//  Copyright © 2020 Sun Asterisk. All rights reserved.
//

import UIKit

final class ListSectionLayout: SectionLayout {
    init() {
        let layout = LayoutOptions(
            itemSpacing: 8,
            lineSpacing: 8,
            itemsPerRow: 1,
            sectionInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
            itemHeight: 100,
            itemWidth: 0
        )
        
        super.init(sectionType: .list, layout: layout, cellType: ListPageItemCell.self)
    }
}
