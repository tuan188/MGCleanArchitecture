//
//  ProductCell.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/5/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

import UIKit

final class ProductCell: UITableViewCell, NibReusable {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var iconImageView: UIImageView!
    
    var editProductAction: (() -> Void)?
    var deleteProductAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func bindViewModel(_ viewModel: ProductItemViewModel?) {
        if let viewModel = viewModel {
            nameLabel.text = viewModel.name
            priceLabel.text = viewModel.price
            iconImageView.image = viewModel.icon
            backgroundColor = viewModel.backgroundColor
        } else {
            nameLabel.text = ""
            priceLabel.text = ""
            iconImageView.image = nil
            backgroundColor = ColorCompatibility.systemBackground
        }
    }
    
    @IBAction func edit(_ sender: Any) {
        editProductAction?()
    }
    
    @IBAction func deleteProduct(_ sender: Any) {
        deleteProductAction?()
    }
    
}

