//
//  ProductHeaderView.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 9/7/18.
//  Copyright © 2018 Framgia. All rights reserved.
//

import UIKit

final class ProductHeaderView: UITableViewHeaderFooterView, NibReusable {
    @IBOutlet weak var titleLabel: UILabel!

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
