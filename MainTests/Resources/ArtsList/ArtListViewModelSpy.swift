@testable import Main

final class ArtListViewModelSpy: ArtListViewModelProtocol {
    private(set) var fetchArtListCalled: [Bool] = []
    func fetchArtList() {
        fetchArtListCalled.append(true)
    }

    func prefetchNextPage() {
        
    }

    func refreshArtsList() {

    }
}
