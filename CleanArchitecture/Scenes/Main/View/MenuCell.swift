//
//  MenuCell.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/4/18.
//  Copyright © 2018 Framgia. All rights reserved.
//

import UIKit

final class MenuCell: UITableViewCell, NibReusable {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configView(with: nil)
    }
    
    func configView(with model: MainViewModel.MenuModel?) {
        guard let model = model else {
            titleLabel.text = ""
            return
        }
        titleLabel.text = model.menu.description
    }
}
