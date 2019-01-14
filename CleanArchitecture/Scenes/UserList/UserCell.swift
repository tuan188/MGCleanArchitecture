//
//  UserCell.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 1/14/19.
//  Copyright © 2019 Framgia. All rights reserved.
//

import UIKit

final class UserCell: UITableViewCell, NibReusable {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bindViewModel(_ viewModel: UserViewModel?) {
        nameLabel.text = viewModel?.name
        genderLabel.text = viewModel?.gender
        birthdayLabel.text = viewModel?.birthday
    }
}
