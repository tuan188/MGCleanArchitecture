import MJRefresh
import UIKit

class RefreshTableView: UITableView {
    var refreshing: Binder<Bool> {
        return Binder(self) { collectionView, loading in
            if loading {
                collectionView.mj_header?.beginRefreshing()
            } else {
                collectionView.mj_header?.endRefreshing()
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
    
    private var _refreshTrigger = PublishSubject<Void>()
    var refreshTrigger: Driver<Void> {
        return _refreshTrigger.asDriverOnErrorJustComplete()
    }
    
    private var _loadMoreTrigger = PublishSubject<Void>()
    var loadMoreTrigger: Driver<Void> {
        return _loadMoreTrigger.asDriverOnErrorJustComplete()
    }
    
    var refreshHeader: MJRefreshHeader? {
        didSet {
            mj_header = refreshHeader
            mj_header.refreshingBlock = { [weak self] in
                self?._refreshTrigger.onNext(())
            }
        }
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
        self.refreshHeader = RefreshAutoHeader(refreshingBlock: nil)
        self.refreshFooter = RefreshAutoFooter(refreshingBlock: nil)
    }
}
