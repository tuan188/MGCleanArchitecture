import UIKit
import MJRefresh

class LoadMoreCollectionView: UICollectionView {
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
    
    var refreshFooter: MJRefreshFooter? {
        didSet {
            mj_footer = refreshFooter
            mj_footer.refreshingBlock = { [weak self] in
                self?._loadMoreTrigger.onNext(())
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(_refreshControl)
        self.refreshFooter = RefreshAutoFooter(refreshingBlock: nil)
    }
}
