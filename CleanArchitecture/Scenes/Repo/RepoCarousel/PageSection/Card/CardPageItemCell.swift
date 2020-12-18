//
//  CardPageItemCell.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 18/12/2020.
//  Copyright © 2020 Sun Asterisk. All rights reserved.
//

import UIKit
import SDWebImage

final class CardPageItemCell: PageItemCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func bindViewModel(_ viewModel: PageItemViewModel) {
        super.bindViewModel(viewModel)
        titleLabel.text = viewModel.title
        imageView.sd_setImage(with: viewModel.imageURL, completed: nil)
    }

}
