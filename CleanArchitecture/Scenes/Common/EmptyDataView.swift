//
//  EmptyDataView.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 9/5/18.
//  Copyright © 2018 Framgia. All rights reserved.
//

import UIKit

final class EmptyDataView: UIView, NibOwnerLoadable {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadNibContent()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadNibContent()
    }

}
