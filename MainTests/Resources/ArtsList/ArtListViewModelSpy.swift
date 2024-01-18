@testable import Main

final class ArtListViewModelSpy: ArtListViewModelProtocol {
    private(set) var fetchArtListCalled: [Bool] = []
    func fetchArtList(isPrefetch: Bool) {
        fetchArtListCalled.append(true)
    }
}
