//
//  RepoCollectionCell.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 7/9/18.
//  Copyright © 2018 Framgia. All rights reserved.
//

import UIKit

final class RepoCollectionCell: UICollectionViewCell, NibReusable {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarURLStringImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bindViewModel(_ viewModel: RepoViewModel?) {
        if let viewModel = viewModel {
            nameLabel.text = viewModel.name
            avatarURLStringImageView.sd_setImage(with: viewModel.url, completed: nil)
        } else {
            nameLabel.text = ""
            avatarURLStringImageView.image = nil
        }
    }
}
