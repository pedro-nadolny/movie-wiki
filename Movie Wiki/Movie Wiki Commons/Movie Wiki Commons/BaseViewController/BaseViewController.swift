import UIKit

open class BaseViewController: UIViewController {
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func showAlert(with title: String?, and message: String?) {
        showAlertController(with: title, message: message, and: .alert)
    }
    
    func showActionSheet(with title: String?, and message: String?) {
        showAlertController(with: title, message: message, and: .actionSheet)
    }
    
    fileprivate func showAlertController(with title: String?, message: String?, and type: UIAlertController.Style) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: type)
        
        alert.addAction (
            UIAlertAction(title: "Close", style: .default) { (action) in
                alert.dismiss(animated: true)
            }
        )
        
        self.present(alert, animated: true)
    }
}
