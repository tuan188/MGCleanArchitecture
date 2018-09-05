//
//  UICollectionView+.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 9/5/18.
//  Copyright © 2018 Framgia. All rights reserved.
//

import UIKit

extension UICollectionView {
    var isEmptyData: Binder<Bool> {
        return Binder(self) { collectionView, isEmptyData in
            if isEmptyData {
                let frame = CGRect(x: 0,
                                   y: 0,
                                   width: collectionView.frame.size.width,
                                   height: collectionView.frame.size.height)
                let emptyView = EmptyDataView(frame: frame)
                collectionView.backgroundView = emptyView
            } else {
                collectionView.backgroundView = nil
            }
        }
    }
}
