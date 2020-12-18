//
//  CardSectionLayout.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 18/12/2020.
//  Copyright © 2020 Sun Asterisk. All rights reserved.
//

import UIKit

final class CardSectionLayout: SectionLayout {
    init() {
        let layout = LayoutOptions(
            itemSpacing: 8,
            lineSpacing: 8,
            itemsPerRow: 3,
            sectionInsets: UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16),
            itemHeight: 200,
            itemWidth: 0
        )
        
        super.init(sectionType: .card, layout: layout, cellType: CardPageItemCell.self)
    }
}
