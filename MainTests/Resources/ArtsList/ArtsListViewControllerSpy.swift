@testable import Main

final class ArtsListViewControllerSpy: ArtsListOutputProtocol {
    private(set) var receivedFetchArtsListAlertErrorModel: [AlertErrorModel] = []
    func showFetchArtsListError(with alertErrorModel: AlertErrorModel) {
        receivedFetchArtsListAlertErrorModel.append(alertErrorModel)
    }
    
    func showPrefetchError() {}
    
    func showRefreshedArtsListError(with alertErrorModel: AlertErrorModel) {}

    func showArtsList(with artItems: [ArtItemView]) {}
    
    func showPrefetchedArtsList(with prefetchedArtItems: [ArtItemView]) {}
    
    func showRefreshedArtsList(with refreshedArtItems: [ArtItemView]) {}
    
    func updateArtImage(with artImage: ArtImageModel) {}
}
