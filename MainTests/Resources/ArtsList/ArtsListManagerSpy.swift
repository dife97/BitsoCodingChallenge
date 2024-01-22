import ArtApp

final class ArtsListManagerSpy: ArtsListProtocol {
    private(set) var receivedIsFreshingValues: [Bool] = []
    private(set) var receivedCompletion: [(ArtsListResult) -> Void] = []
    func getArtsList(
        isRefreshing: Bool,
        completion: @escaping (ArtsListResult) -> Void
    ) {
        receivedIsFreshingValues.append(isRefreshing)
        receivedCompletion.append(completion)
    }

    func complete(with result: ArtsListResult) {
        receivedCompletion.first?(result)
    }
}
