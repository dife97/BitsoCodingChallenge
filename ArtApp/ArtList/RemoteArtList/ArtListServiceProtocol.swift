public protocol ArtListServiceProtocol {
    func getArtList(
        requestModel: ArtListRequestModel,
        _ completion: @escaping (RemoteArtListResult) -> Void
    )
}

public typealias RemoteArtListResult = Result<ArtListResponseModel, ArtServiceError>
