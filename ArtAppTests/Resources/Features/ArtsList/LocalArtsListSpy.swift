@testable import ArtApp

final class LocalArtsListSpy: LocalArtsListProtocol {
    private(set) var receivedModelToSave: ArtsList = []
    func saveArtsList(
        model: ArtsList,
        completion: @escaping (ArtsListStoreError?) -> Void
    ) {
        receivedModelToSave = model
    }

    private(set) var getArtsListCalled: [Bool] = []
    private(set) var receivedGetArtsListCompletion: [(LocalArtsListResult) -> Void] = []
    func getArtsList(completion: @escaping (LocalArtsListResult) -> Void) {
        getArtsListCalled.append(true)
        receivedGetArtsListCompletion.append(completion)
    }

    func completeGetArtsList(with result: LocalArtsListResult) {
        receivedGetArtsListCompletion.first?(result)
    }
}
