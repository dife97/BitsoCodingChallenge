import ArtApp

final class RemoteArtListServiceSpy: RemoteArtListProtocol {
    private(set) var receivedRequestModel: [ArtListRequestModel] = []

    func getArtList(
        requestModel: ArtListRequestModel,
        _ completion: @escaping (ArtApp.RemoteArtListResult) -> Void
    ) {
        receivedRequestModel.append(requestModel)
    }
}
