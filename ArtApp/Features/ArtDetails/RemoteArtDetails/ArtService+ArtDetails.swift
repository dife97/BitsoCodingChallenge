import ArtNetwork

extension ArtService: ArtDetailsServiceProtocol {
    public func getArtDetails(
        requestModel: ArtDetailsRequestModel,
        _ completion: @escaping (RemoteArtDetailsResult) -> Void
    ) {
        let getArtDetailsTarget: ArtServiceTarget = .getArtDetails(requestModel)

        provider.request(target: getArtDetailsTarget) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let data):
                if let model: ArtDetailsResponseModel = data?.toModel() {
                    completion(.success(model))
                } else {
                    completion(.failure(.invalidData))
                }

            case .failure(let error):
                completion(.failure(getArtDetailsServiceError(from: error)))
            }
        }
    }

    // MARK: - Private Methods
    private func getArtDetailsServiceError(from providerError: HTTPProviderError) -> ArtServiceError {
        switch providerError {
        case .connection:
            return .connection
        case .invalidRequest, .invalidData, .unexpected:
            return .unexpected
        }
    }
}
