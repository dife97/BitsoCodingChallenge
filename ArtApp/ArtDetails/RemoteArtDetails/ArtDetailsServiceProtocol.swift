protocol ArtDetailsServiceProtocol {
    func getArtDetails(
        requestModel: ArtDetailsRequestModel,
        _ completion: @escaping (RemoteArtDetailsResult) -> Void
    )
}

typealias RemoteArtDetailsResult = Result<ArtDetailsResponseModel, ArtServiceError>
