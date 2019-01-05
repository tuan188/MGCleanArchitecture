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
    
    func configData(menu: MainViewModel.Menu?) {
        titleLabel.text = menu?.description
    }
}
