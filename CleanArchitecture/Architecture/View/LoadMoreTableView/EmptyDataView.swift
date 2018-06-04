import UIKit
import Reusable

class EmptyDataView: UIView, NibOwnerLoadable {

    @IBOutlet weak var messageLabel: UILabel!
    
    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadNibContent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNibContent()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func showEmptyViewWithMessage(message: String) {
        messageLabel.text = message
    }
}
