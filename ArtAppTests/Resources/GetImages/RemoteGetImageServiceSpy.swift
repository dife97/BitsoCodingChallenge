import ArtApp

final class RemoteGetImageServiceSpy: GetImageServiceProtocol {
    private(set) var receivedImageRequestModels: [ArtImageRequestModel] = []
    private var receivedCompletions: [(RemoteGetImageResult) -> Void] = []

    func getArtImage(
        requestModel: ArtImageRequestModel,
        _ completion: @escaping (RemoteGetImageResult) -> Void
    ) {
        receivedImageRequestModels.append(requestModel)
        receivedCompletions.append(completion)
    }

    func complete(
        with result: RemoteGetImageResult,
        completionAtIndex index: Int = 0
    ) {
        receivedCompletions[index](result)
    }
}
