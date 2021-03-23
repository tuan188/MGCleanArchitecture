//
//  CarouselSectionLayout.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 23/12/2020.
//  Copyright © 2020 Sun Asterisk. All rights reserved.
//

import UIKit

final class CarouselSectionLayout: SectionLayout {
    init() {
        let layout = LayoutOptions(
            itemSpacing: 16,
            lineSpacing: 32,
            itemsPerRow: 1,
            sectionInsets: UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0),
            itemHeight: 200,
            itemWidth: 0
        )
        
        super.init(sectionType: .carousel, layout: layout, cellType: CarouselPageItemCell.self)
        
        self.childLayout = LayoutOptions(
            itemSpacing: 16,
            lineSpacing: 16,
            itemsPerRow: 1,
            sectionInsets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16),
            itemHeight: 200,
            itemWidth: 200
        )
        
        self.childCellType = CarouselPageItemChildCell.self
    }
}
