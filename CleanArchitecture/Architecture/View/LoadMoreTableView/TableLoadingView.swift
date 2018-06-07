import UIKit
import RxSwift
import RxCocoa
import Reusable
import NSObject_Rx

class TableLoadingView: UIView, NibLoadable {
    
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    var isLoading = BehaviorRelay(value: false)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        isLoading.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self](loading) in
                if loading {
                    self?.loadingIndicator.startAnimating()
                } else {
                    self?.loadingIndicator.stopAnimating()
                }
            })
            .disposed(by: rx.disposeBag)
    }
}
