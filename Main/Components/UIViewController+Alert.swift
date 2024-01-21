import UIKit

extension UIViewController {
    func showAlert(
        title: String,
        message: String,
        buttonTitle: String,
        action: (() -> Void)? = nil
    ) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let alertAction = UIAlertAction(
            title: buttonTitle,
            style: .default,
            handler: { _ in
                action?()
            }
        )
        alertController.addAction(alertAction)
        
        if let navigationController {
            navigationController.present(alertController, animated: true)
        } else {
            present(alertController, animated: true)
        }
    }
}
