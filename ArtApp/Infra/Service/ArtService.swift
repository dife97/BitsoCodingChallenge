import ArtNetwork

public final class ArtService {
    let provider: HTTPProviderProtocol

    public init(provider: HTTPProviderProtocol) {
        self.provider = provider
    }
}


// MARK: - ArtImage
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

    private func getImageServiceError(from providerError: HTTPProviderError) -> ArtServiceError {
        switch providerError {
        case .connection:
            return .connection
        case .invalidRequest, .invalidData, .unexpected:
            return .unexpected
        }
    }
}

// MARK: - Art Details
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

    private func getArtDetailsServiceError(from providerError: HTTPProviderError) -> ArtServiceError {
        switch providerError {
        case .connection:
            return .connection
        case .invalidRequest, .invalidData, .unexpected:
            return .unexpected
        }
    }
}
