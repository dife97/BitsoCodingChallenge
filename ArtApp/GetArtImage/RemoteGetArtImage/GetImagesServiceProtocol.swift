public protocol GetImageServiceProtocol {
    func getArtImage(
        requestModel: ArtImageRequestModel,
        _ completion: @escaping (RemoteGetImageResult) -> Void
    )
}

public typealias RemoteGetImageResult = Result<ArtImageResponse, GetImageServiceError>

