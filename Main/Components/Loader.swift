import UIKit

extension UIView {
    var loaderTag: Int { 1111 }

    func startLoading() {
        let loader = UIActivityIndicatorView()
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.tag = loaderTag
        loader.color = .label

        addSubview(loader)
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        loader.startAnimating()
    }

    func stopLoading() {
        guard let loader = viewWithTag(loaderTag) as? UIActivityIndicatorView else { return }
        loader.stopAnimating()
        loader.removeFromSuperview()
    }
}
