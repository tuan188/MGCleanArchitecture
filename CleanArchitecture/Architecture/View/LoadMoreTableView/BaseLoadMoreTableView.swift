import UIKit
import RxSwift

class UITableViewDelegateTransporter: DelegateTransporter, UITableViewDelegate {
    @nonobjc convenience init(delegates: [UITableViewDelegate]) {
        self.init(__delegates: delegates)
    }
}

class BaseLoadMoreTableView: UITableView {
    
    var topOffset: CGFloat = -50
    var bottomOffset: CGFloat = 0
    
    // MARK: - Delegate
    private var delegateTransporter: UITableViewDelegateTransporter? {
        didSet { self.delegate = delegateTransporter }
    }
    
    public weak var loadMoreDelegate: UITableViewDelegate? {
        didSet {
            guard let loadMoreDelegate = loadMoreDelegate else {
                delegateTransporter = nil
                return
            }
            delegateTransporter = UITableViewDelegateTransporter(delegates: [loadMoreDelegate, self])
        }
    }
    
    // MARK: - Reached Top
    private lazy var _reachedTop: Bool = {
        return self.contentOffset.y < self.topOffset
    }()
    
    fileprivate(set) var reachedTop: Bool {
        set {
            let oldValue = _reachedTop
            _reachedTop = newValue
            if _reachedTop == oldValue { return }
            guard _reachedTop else { return }
            scrollViewDidReachTop?(self)
        }
        get {
            return _reachedTop
        }
    }
    public var scrollViewDidReachTop: ((UIScrollView) -> Void)?
    
    // MARK: - Reached Bottom
    private lazy var _reachedBottom: Bool = {
        let maxScrollDistance = max(0, self.contentSize.height - self.bounds.size.height)
        return self.contentOffset.y >= (maxScrollDistance + self.bottomOffset)
    }()
    
    fileprivate(set) var reachedBottom: Bool {
        set {
            let oldValue = _reachedBottom
            _reachedBottom = newValue
            if _reachedBottom == oldValue { return }
            guard _reachedBottom else { return }
            scrollViewDidReachBottom?(self)
        }
        get {
            return _reachedBottom
        }
    }
    
    public var scrollViewDidReachBottom: ((UIScrollView) -> Void)?
}

extension BaseLoadMoreTableView: UITableViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let hasContent = scrollView.contentSize.height > 0
        reachedTop = scrollView.contentOffset.y < topOffset && hasContent
        let maxScrollDistance = max(0, scrollView.contentSize.height - scrollView.bounds.size.height)
        reachedBottom = scrollView.contentOffset.y >= (maxScrollDistance + self.bottomOffset) && hasContent
    }
}
