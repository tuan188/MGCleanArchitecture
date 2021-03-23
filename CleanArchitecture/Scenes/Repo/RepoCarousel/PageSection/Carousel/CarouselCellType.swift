//
//  CarouselCellType.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 15/03/2021.
//  Copyright © 2021 Sun Asterisk. All rights reserved.
//

import UIKit

protocol CarouselCellType: class {
    var collectionViewOffset: CGFloat { get set }
    var collectionView: CarouselCollectionView! { get }
}

typealias UICollectionViewDataSourceDelegate = UICollectionViewDataSource
    & UICollectionViewDelegate

extension CarouselCellType {
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSourceDelegate>(
        _ dataSourceDelegate: D,
        for section: Int) {
        collectionView.do {
            $0.delegate = dataSourceDelegate
            $0.dataSource = dataSourceDelegate
            $0.tag = section
            $0.setContentOffset($0.contentOffset, animated: false)
            $0.reloadData()
        }
    }
}
