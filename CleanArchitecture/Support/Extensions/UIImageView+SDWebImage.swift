//
//  UIImageView+SDWebImage.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 7/5/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

import UIKit

extension UIImageView {
    func setImage(with url: URL?, completion: (() -> Void)? = nil) {
        self.sd_setImage(with: url, placeholderImage: nil, options: .refreshCached) { (_, _, _, _) in
            completion?()
        }
    }
}
