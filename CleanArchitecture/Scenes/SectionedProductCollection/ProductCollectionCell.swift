//
//  ProductCollectionCell.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 9/9/20.
//  Copyright © 2020 Sun Asterisk. All rights reserved.
//

import UIKit
import Reusable

final class ProductCollectionCell: UICollectionViewCell, NibReusable {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    var editProductAction: (() -> Void)?
    
    func bindViewModel(_ viewModel: ProductItemViewModel) {
        nameLabel.text = viewModel.name
        priceLabel.text = viewModel.price
        containerView.backgroundColor = viewModel.backgroundColor
    }
    
    @IBAction func edit(_ sender: Any) {
        editProductAction?()
    }
}
