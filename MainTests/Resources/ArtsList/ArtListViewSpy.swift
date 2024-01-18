@testable import Main

final class ArtListViewSpy: ArtListViewProtocol {
    private(set) var receivedLoadingStates: [Bool] = []
    func setLoadingState(to isLoading: Bool) {
        receivedLoadingStates.append(isLoading)
    }

    func loadArtsList(with artsList: [ArtItemView]) {}

    func updateArtImage(with artImage: ArtImageModel) {}
}
