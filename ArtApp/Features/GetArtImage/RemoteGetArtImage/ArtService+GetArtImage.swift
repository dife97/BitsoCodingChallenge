import ArtNetwork

extension ArtService: GetImageServiceProtocol {
    public func getArtImage(
        requestModel: ArtImageRequestModel,
        _ completion: @escaping (RemoteGetImageResult) -> Void
    ) {
        let getArtImageTarget: ArtServiceTarget = .getArtImage(requestModel)

        provider.request(target: getArtImageTarget) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let data):
                guard let data else {
                    return completion(.failure(.invalidData))
                }

                if data.isEmpty {
                    completion(.failure(.invalidData))
                } else {
                    completion(.success(.init(imageData: data)))
                }

            case .failure(let error):
                completion(.failure(getImageServiceError(from: error)))
            }
        }
    }

    // MARK: - Private Methods
    private func getImageServiceError(from providerError: HTTPProviderError) -> ArtServiceError {
        switch providerError {
        case .connection:
            return .connection
        case .invalidRequest, .invalidData, .unexpected:
            return .unexpected
        }
    }
}
