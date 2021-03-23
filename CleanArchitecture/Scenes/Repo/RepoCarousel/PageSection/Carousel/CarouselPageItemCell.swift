//
//  CarouselPageItemCell.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 23/12/2020.
//  Copyright © 2020 Sun Asterisk. All rights reserved.
//

import UIKit
import Reusable

final class CarouselPageItemCell: PageItemCell, CarouselCellType {
    
    @IBOutlet weak var collectionView: CarouselCollectionView!
    
    var collectionViewOffset: CGFloat {
        get { return collectionView.contentOffset.x }
        set { collectionView.contentOffset.x = newValue }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }
    
    private func configView() {
        collectionView.do {
            $0.register(cellType: CarouselPageItemChildCell.self)
            $0.decelerationRate = UIScrollView.DecelerationRate.fast
            ($0.collectionViewLayout as? SnappingCollectionViewLayout)?.scrollDirection = .horizontal
        }
    }

}
