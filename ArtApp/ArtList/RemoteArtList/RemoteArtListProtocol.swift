public protocol RemoteArtListProtocol {
    func getArtList(
        requestModel: ArtListRequestModel,
        _ completion: @escaping (RemoteArtListResult) -> Void
    )
}

public typealias RemoteArtListResult = Result<ArtListResponseModel, HTTPError>
