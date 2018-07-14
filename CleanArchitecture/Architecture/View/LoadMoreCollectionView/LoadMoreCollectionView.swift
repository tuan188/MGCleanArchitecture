//
//  LoadMoreCollectionView.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 7/14/18.
//  Copyright © 2018 Framgia. All rights reserved.
//

import UIKit
import MJRefresh

final class LoadMoreCollectionView: UICollectionView {
    private let _refreshControl = UIRefreshControl()
    
    var refreshing: Binder<Bool> {
        return Binder(self) { collectionView, loading in
            if loading {
                collectionView._refreshControl.beginRefreshing()
            } else {
                if collectionView._refreshControl.isRefreshing {
                    collectionView._refreshControl.endRefreshing()
                }
            }
        }
    }
    
    var loadingMore: Binder<Bool> {
        return Binder(self) { collectionView, loading in
            if loading {
                collectionView.mj_footer?.beginRefreshing()
            } else {
                collectionView.mj_footer?.endRefreshing()
            }
        }
    }
    
    var refreshTrigger: Driver<Void> {
        return _refreshControl.rx.controlEvent(.valueChanged).asDriver()
    }
    
    private var _loadMoreTrigger = PublishSubject<Void>()
    var loadMoreTrigger: Driver<Void> {
        return _loadMoreTrigger.asDriverOnErrorJustComplete()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(_refreshControl)
        self.mj_footer = RefreshAutoFooter(refreshingBlock: { [weak self] in
            self?._loadMoreTrigger.onNext(())
        })
    }
}
