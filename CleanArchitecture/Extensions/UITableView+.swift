import UIKit

extension UITableView {
    var isEmptyData: Binder<Bool> {
        return Binder(self) { tableView, isEmptyData in
            if isEmptyData {
                let frame = CGRect(x: 0,
                                   y: 0,
                                   width: tableView.frame.size.width,
                                   height: tableView.frame.size.height)
                let emptyView = EmptyDataView(frame: frame)
                tableView.backgroundView = emptyView
            } else {
                tableView.backgroundView = nil
            }
        }
    }
}
