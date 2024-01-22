@testable import ArtApp

final class RemoteArtsListSpy: RemoteArtsListProtocol {
    private(set) var receivedModel: [ArtsListRequestModel] = []
    private(set) var receivedCompletion: [(RemoteArtListResult) -> Void] = []
    func getArtsList(
        requestModel: ArtsListRequestModel,
        completion: @escaping (RemoteArtListResult) -> Void
    ) {
        receivedModel.append(requestModel)
        receivedCompletion.append(completion)
    }

    func complete(with result: RemoteArtListResult) {
        receivedCompletion.first?(result)
    }
}
