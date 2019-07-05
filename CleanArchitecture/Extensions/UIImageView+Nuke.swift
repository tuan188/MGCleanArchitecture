//
//  UIImageView+Nuke.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 7/5/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

import UIKit

extension UIImageView {
    func setImage(with url: URL?, completion: (() -> Void)? = nil) {
        self.backgroundColor = backgroundColor
        if let url = url {
            Nuke.loadImage(
                with: url,
                options: ImageLoadingOptions(
                    transition: .fadeIn(duration: 0.33)
                ),
                into: self,
                completion: { _, _ in
                    completion?()
                }
            )
        }
    }
}
