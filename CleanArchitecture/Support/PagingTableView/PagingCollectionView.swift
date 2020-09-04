//
//  PagingCollectionView.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 9/4/20.
//  Copyright © 2020 Sun Asterisk. All rights reserved.
//

import UIKit
import RxCocoa
import MJRefresh

open class PagingCollectionView: UICollectionView {
    private let _refreshControl = UIRefreshControl()
    
    open var isRefreshing: Binder<Bool> {
        return Binder(self) { collectionView, loading in
            if collectionView.refreshHeader == nil {
                if loading {
                    collectionView._refreshControl.beginRefreshing()
                } else {
                    if collectionView._refreshControl.isRefreshing {
                        collectionView._refreshControl.endRefreshing()
                    }
                }
            } else {
                if loading {
                    collectionView.mj_header?.beginRefreshing()
                } else {
                    collectionView.mj_header?.endRefreshing()
                }
            }
        }
    }
    
    open var isLoadingMore: Binder<Bool> {
        return Binder(self) { collectionView, loading in
            if loading {
                collectionView.mj_footer?.beginRefreshing()
            } else {
                collectionView.mj_footer?.endRefreshing()
            }
        }
    }
    
    private var _refreshTrigger = PublishSubject<Void>()
    
    open var refreshTrigger: Driver<Void> {
        if refreshHeader == nil {
            return _refreshControl.rx.controlEvent(.valueChanged).asDriver()
        } else {
            return _refreshTrigger.asDriverOnErrorJustComplete()
        }
    }
    
    private var _loadMoreTrigger = PublishSubject<Void>()
    
    open var loadMoreTrigger: Driver<Void> {
        _loadMoreTrigger.asDriverOnErrorJustComplete()
    }
    
    open var refreshHeader: MJRefreshHeader? {
        didSet {
            mj_header = refreshHeader
            mj_header?.refreshingBlock = { [weak self] in
                self?._refreshTrigger.onNext(())
            }
            
            removeRefreshControl()
        }
    }
    
    open var refreshFooter: MJRefreshFooter? {
        didSet {
            mj_footer = refreshFooter
            mj_footer?.refreshingBlock = { [weak self] in
                self?._loadMoreTrigger.onNext(())
            }
        }
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        addSubview(_refreshControl)
        refreshFooter = RefreshAutoFooter()
    }
    
    func addRefreshControl() {
        guard !self.subviews.contains(_refreshControl) else { return }
        
        refreshHeader = nil
        addSubview(_refreshControl)
    }
    
    func removeRefreshControl() {
        _refreshControl.removeFromSuperview()
    }
}
