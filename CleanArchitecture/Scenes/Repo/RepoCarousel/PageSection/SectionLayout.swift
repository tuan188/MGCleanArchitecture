//
//  PageSectionLayout.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 16/12/2020.
//  Copyright © 2020 Sun Asterisk. All rights reserved.
//

import Foundation

class SectionLayout {  // swiftlint:disable:this final_class
    
    var sectionType: SectionType
    var layout: LayoutOptions
    var cellType: PageItemCell.Type
    var childLayout: LayoutOptions?
    var childCellType: PageItemCell.Type?
    
    var hasChild: Bool {
        return childLayout != nil && childCellType != nil
    }
    
    init(sectionType: SectionType,
         layout: LayoutOptions,
         cellType: PageItemCell.Type) {
        self.sectionType = sectionType
        self.layout = layout
        self.cellType = cellType
    }
}
