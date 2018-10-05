import UIKit
import MJRefresh

class RefreshAutoHeader: MJRefreshHeader {
    var activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray {
        didSet {
            _loadingView = nil
            setNeedsLayout()
        }
    }
    
    private var _loadingView: UIActivityIndicatorView?
    
    var loadingView: UIActivityIndicatorView {
        if _loadingView == nil {
            let view = UIActivityIndicatorView(activityIndicatorStyle: self.activityIndicatorViewStyle)
            view.hidesWhenStopped = true
            self.addSubview(view)
            _loadingView = view
        }
        return _loadingView!
    }
    
    override func prepare() {
        super.prepare()
        activityIndicatorViewStyle = .gray
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        let center = CGPoint(x: mj_w * 0.5, y: mj_h * 0.5)
        if loadingView.constraints.count == 0 {
            loadingView.center = center
        }
    }
    
    override var state: MJRefreshState {
        didSet {
            switch state {
            case .idle:
                if oldValue == .refreshing {
                    UIView.animate(withDuration: TimeInterval(MJRefreshSlowAnimationDuration), animations: {
                        self.loadingView.alpha = 0
                    }) { (finished) in
                        self.loadingView.alpha = 1
                        self.loadingView.stopAnimating()
                    }
                } else {
                    loadingView.stopAnimating()
                }
            case .pulling:
                loadingView.startAnimating()
            case .refreshing:
                loadingView.startAnimating()
            case .noMoreData:
                loadingView.stopAnimating()
            default:
                break
            }
        }
    }
}
