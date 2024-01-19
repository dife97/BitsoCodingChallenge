public protocol ArtDetailsServiceProtocol {
    func getArtDetails(
        requestModel: ArtDetailsRequestModel,
        _ completion: @escaping (RemoteArtDetailsResult) -> Void
    )
}

public typealias RemoteArtDetailsResult = Result<ArtDetailsResponseModel, ArtServiceError>
