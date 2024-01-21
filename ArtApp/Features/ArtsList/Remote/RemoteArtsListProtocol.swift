public protocol RemoteArtsListProtocol {
    func getArtsList(
        requestModel: ArtsListRequestModel,
        completion: @escaping (RemoteArtListResult) -> Void
    )
}

public typealias RemoteArtListResult = Result<ArtsListResponseModel, ArtServiceError>
