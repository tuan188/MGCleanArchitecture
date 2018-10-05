import MJRefresh
import UIKit

class RefreshTableView: UITableView {
    var loadingMoreTop: Binder<Bool> {
        return Binder(self) { collectionView, loading in
            if loading {
                collectionView.mj_header?.beginRefreshing()
            } else {
                collectionView.mj_header?.endRefreshing()
            }
        }
    }
    
    var loadingMoreBottom: Binder<Bool> {
        return Binder(self) { collectionView, loading in
            if loading {
                collectionView.mj_footer?.beginRefreshing()
            } else {
                collectionView.mj_footer?.endRefreshing()
            }
        }
    }
    
    private var _loadMoreTopTrigger = PublishSubject<Void>()
    var loadMoreTopTrigger: Driver<Void> {
        return _loadMoreTopTrigger.asDriverOnErrorJustComplete()
    }
    
    private var _loadMoreBottomTrigger = PublishSubject<Void>()
    var loadMoreBottomTrigger: Driver<Void> {
        return _loadMoreBottomTrigger.asDriverOnErrorJustComplete()
    }
    
    var refreshHeader: MJRefreshHeader? {
        didSet {
            mj_header = refreshHeader
            mj_header?.refreshingBlock = { [weak self] in
                self?._loadMoreTopTrigger.onNext(())
            }
        }
    }
    
    var refreshFooter: MJRefreshFooter? {
        didSet {
            mj_footer = refreshFooter
            mj_footer?.refreshingBlock = { [weak self] in
                self?._loadMoreBottomTrigger.onNext(())
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.refreshHeader = RefreshAutoHeader(refreshingBlock: nil)
        self.refreshFooter = RefreshAutoFooter(refreshingBlock: nil)
    }
}
