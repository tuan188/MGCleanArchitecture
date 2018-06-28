//
// RepoCell.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/28/18.
// Copyright © 2018 Framgia. All rights reserved.
//

import UIKit

final class RepoCell: UITableViewCell, NibReusable {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarURLStringImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configView(with: nil)
    }
    
    func configView(with model: ReposViewModel.RepoModel?) {
        if let repo = model?.repo {
            nameLabel.text = repo.name
            let url = URL(string: repo.avatarURLString)
            avatarURLStringImageView.sd_setImage(with: url, completed: nil)
        } else {
            nameLabel.text = ""
            avatarURLStringImageView.image = nil
        }
    }
}

