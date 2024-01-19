import UIKit

protocol ArtItemViewFactory {
    func makeArtItemView() -> UIView
    func getCellHeight() -> CGFloat
}

typealias ArtItemViews = [ArtItemViewFactory]
