//
// SectionedProductCell.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/7/18.
// Copyright © 2018 Framgia. All rights reserved.
//

import UIKit

final class SectionedProductCell: UITableViewCell, NibReusable {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    var editProductAction: (() -> Void)?
    
    func bindViewModel(_ viewModel: ProductViewModel?) {
        if let viewModel = viewModel {
            nameLabel.text = viewModel.name
            priceLabel.text = viewModel.price
        } else {
            nameLabel.text = ""
            priceLabel.text = ""
        }
    }
    
    @IBAction func edit(_ sender: Any) {
        editProductAction?()
    }
}

