import UIKit

class BaseViewController: UIViewController {
    func showAlert(with title: String?, and message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        alert.addAction (
            UIAlertAction(title: "Close", style: .default) { (action) in
                alert.dismiss(animated: true)
            }
        )
        
        self.present(alert, animated: true)
    }
}
