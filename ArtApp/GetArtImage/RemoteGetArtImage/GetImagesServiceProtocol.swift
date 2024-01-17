public protocol GetImageServiceProtocol {
    func getImage(
        requestModel: ArtImageRequestModel,
        _ completion: @escaping (RemoteGetImageResult) -> Void
    )
}

public typealias RemoteGetImageResult = Result<ArtImageResponse, GetImageServiceError>

