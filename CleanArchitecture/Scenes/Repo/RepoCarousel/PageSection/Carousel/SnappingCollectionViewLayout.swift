//
//  SnappingCollectionViewLayout.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 15/03/2021.
//  Copyright © 2021 Sun Asterisk. All rights reserved.
//

import UIKit

final class SnappingCollectionViewLayout: UICollectionViewFlowLayout {
    
    static let collectionLeftPadding: CGFloat = 16
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
                                      withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset,
                                             withScrollingVelocity: velocity)
        }
        if abs(velocity.x) <= snapToMostVisibleColumnVelocityThreshold {
            let targetRect = CGRect(x: proposedContentOffset.x,
                                    y: 0,
                                    width: collectionView.bounds.size.width,
                                    height: collectionView.bounds.size.height)
            let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect) ?? []
            if collectionView.bounds.origin.x + collectionView.bounds.size.width
                + SnappingCollectionViewLayout.collectionLeftPadding
                > collectionView.contentSize.width {
                let offsetAdjustment = layoutAttributesArray
                    .max(by: { $0.center.x < $1.center.x })?
                    .frame.origin.x ?? collectionView.contentSize.width
                return CGPoint(x: offsetAdjustment - SnappingCollectionViewLayout.collectionLeftPadding,
                               y: proposedContentOffset.y)
            } else {
                var offsetAdjustment = CGFloat.greatestFiniteMagnitude
                layoutAttributesArray.forEach {
                    if abs($0.frame.origin.x - proposedContentOffset.x) < abs(offsetAdjustment) {
                        offsetAdjustment = $0.frame.origin.x - proposedContentOffset.x
                    }
                }
                return CGPoint(x: proposedContentOffset.x
                                + offsetAdjustment
                                - SnappingCollectionViewLayout.collectionLeftPadding,
                               y: proposedContentOffset.y)
            }
        } else if velocity.x > 0 {
            let targetRect = CGRect(x: proposedContentOffset.x,
                                    y: 0,
                                    width: collectionView.bounds.size.width,
                                    height: collectionView.bounds.size.height)
            let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect) ?? []
            let offsetAdjustment = layoutAttributesArray
                .filter { $0.frame.origin.x > proposedContentOffset.x }
                .min(by: { $0.center.x < $1.center.x })?
                .frame.origin.x ?? 0.0
            return CGPoint(x: offsetAdjustment - SnappingCollectionViewLayout.collectionLeftPadding,
                           y: proposedContentOffset.y)
        } else {
            let targetRect = CGRect(x: proposedContentOffset.x - collectionView.bounds.size.width,
                                    y: 0,
                                    width: collectionView.bounds.size.width,
                                    height: collectionView.bounds.size.height)
            let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect) ?? []
            let offsetAdjustment = layoutAttributesArray
                .max(by: { $0.center.x < $1.center.x })?
                .frame.origin.x ?? 0.0
            return CGPoint(x: offsetAdjustment - SnappingCollectionViewLayout.collectionLeftPadding,
                           y: proposedContentOffset.y)
        }
    }
    
     private var snapToMostVisibleColumnVelocityThreshold: CGFloat { return 0.3 }
}
