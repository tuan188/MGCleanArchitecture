import UIKit

extension UIViewController {
    func logDeinit() {
        print(String(describing: type(of: self)) + " deinit")
    }
}
