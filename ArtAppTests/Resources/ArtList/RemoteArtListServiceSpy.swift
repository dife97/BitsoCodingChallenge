import ArtApp

final class RemoteArtListServiceSpy: ArtListServiceProtocol {
    private(set) var receivedRequestModel: [ArtListRequestModel] = []
    private var receivedCompletion: [(RemoteArtListResult) -> Void] = []

    func getArtList(
        requestModel: ArtListRequestModel,
        _ completion: @escaping (RemoteArtListResult) -> Void
    ) {
        receivedRequestModel.append(requestModel)
        receivedCompletion.append(completion)
    }

    func complete(
        with result: RemoteArtListResult,
        atIndex index: Int = 0
    ) {
        receivedCompletion[index](result)
    }
}
