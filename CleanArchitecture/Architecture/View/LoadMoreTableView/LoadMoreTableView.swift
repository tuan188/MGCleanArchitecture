import UIKit
import RxSwift
import RxCocoa
import Then

final class LoadMoreTableView: BaseLoadMoreTableView {
    private let tableRefreshControl = UIRefreshControl()
    private var loadingMoreView: TableLoadingView!
    private var emptyView: EmptyDataView?
    
    var refreshing: Binder<Bool> {
        return Binder(self) { tableView, loading in
            if loading {
                tableView.tableRefreshControl.beginRefreshing()
            } else {
                if tableView.tableRefreshControl.isRefreshing {
                    tableView.tableRefreshControl.endRefreshing()
                }
            }
        }
    }
    
    var loadingMore: Binder<Bool> {
        return Binder(self) { tableView, loading in
            tableView.loadingMoreView.isLoading.accept(loading)
        }
    }
    
    var refreshTrigger: Driver<Void> {
        return tableRefreshControl.rx.controlEvent(.valueChanged).asDriver()
    }
    
    private var _loadMoreTrigger = PublishSubject<Void>()
    var loadMoreTrigger: Driver<Void> {
        return _loadMoreTrigger.asDriverOnErrorJustComplete()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(tableRefreshControl)
        
        loadingMoreView = TableLoadingView.loadFromNib().with {
            $0.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        }
        self.tableFooterView = loadingMoreView
        
        scrollViewDidReachBottom = { [weak self] _ in
            self?._loadMoreTrigger.onNext(())
        }
    }
}

extension LoadMoreTableView {
    var isEmptyData: Binder<(Bool, String)> {
        return Binder(self) { tableView, data in
            let (isEmptyData, message) = data
            if isEmptyData {
                let frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: tableView.frame.size.height)
                tableView.emptyView = EmptyDataView(frame: frame)
                tableView.emptyView?.showEmptyViewWithMessage(message: message)
                tableView.backgroundView = self.emptyView
            } else {
                tableView.backgroundView = nil
            }
        }
    }
}
