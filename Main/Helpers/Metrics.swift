import UIKit

enum Metrics {}

// MARK: - Spacings
extension Metrics {
    struct Spacings {
        static let x1: CGFloat = 8
        static let x2: CGFloat = 16
        static let x3: CGFloat = 24
        static let x4: CGFloat = 32
        static let x5: CGFloat = 40
    }
}

// MARK: - Radius
extension Metrics {
    struct Radius {
        static let x1: CGFloat = 8
    }
}

// MARK: - Radius
extension UIFont {
    static var smallSize: CGFloat { 14 }
    static var mediumSize: CGFloat { 16 }
    static var titleSize: CGFloat { 18 }

    static var smallBold: UIFont {
        .systemFont(ofSize: smallSize, weight: .bold)
    }

    static var smallLight: UIFont {
        .systemFont(ofSize: smallSize, weight: .light)
    }

    static var mediumBold: UIFont {
        .systemFont(ofSize: mediumSize, weight: .bold)
    }

    static var titleBold: UIFont {
        .systemFont(ofSize: titleSize, weight: .bold)
    }
}
