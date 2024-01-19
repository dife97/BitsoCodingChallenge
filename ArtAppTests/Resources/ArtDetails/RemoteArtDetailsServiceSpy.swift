@testable import ArtApp

final class RemoteArtDetailsServiceSpy: ArtDetailsServiceProtocol {
    private(set) var receivedRequestModel: [ArtDetailsRequestModel] = []
    private var receivedCompletion: [(RemoteArtDetailsResult) -> Void] = []

    func getArtDetails(
        requestModel: ArtDetailsRequestModel,
        _ completion: @escaping (RemoteArtDetailsResult) -> Void
    ) {
        receivedRequestModel.append(requestModel)
        receivedCompletion.append(completion)
    }

    func complete(
        with result: RemoteArtDetailsResult,
        atIndex index: Int = 0
    ) {
        receivedCompletion[index](result)
    }
}
