@testable import Main

final class ArtListViewModelSpy: ArtsListInputProtocol, ArtsListCoordinatorProtocol {
    var showArtDetails: ((ArtDetailsInfoModel) -> Void)?

    private(set) var fetchArtListCalled: [Bool] = []
    func fetchArtList() {
        fetchArtListCalled.append(true)
    }

    func prefetchNextPage() {}

    func refreshArtsList() {}
}
