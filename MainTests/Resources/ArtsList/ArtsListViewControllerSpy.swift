@testable import Main

final class ArtsListViewControllerSpy: ArtListViewModelDelegate {
    private(set) var receivedAlertErrorModel: [AlertErrorModel] = []
    func showErrorAlert(with alertErrorModel: AlertErrorModel) {
        receivedAlertErrorModel.append(alertErrorModel)
    }

    func showArtsList(with artItems: [ArtItemView]) {

    }
    
    func showPrefetchedArtsList(with prefetchedArtItems: [ArtItemView]) {

    }
    
    func showRefreshedArtsList(with refreshedArtItems: [ArtItemView]) {

    }
    
    func updateArtImage(with artImage: ArtImageModel) {

    }
}
