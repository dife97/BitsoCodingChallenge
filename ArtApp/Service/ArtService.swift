import ArtNetwork

public final class ArtService {
    private let provider: HTTPProvider

    public init(provider: HTTPProvider) {
        self.provider = provider
    }
}

// MARK: - Art List
extension ArtService: ArtListServiceProtocol {
    public func getArtList(
        requestModel: ArtListRequestModel,
        _ completion: @escaping (RemoteArtListResult) -> Void
    ) {
        let getArtListTarget: ArtServiceTarget = .getArtList(requestModel)

        provider.request(target: getArtListTarget) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                if let model: ArtListResponseModel = data?.toModel() {
                    completion(.success(model))
                } else {
                    completion(.failure(.dataParsing))
                }

            case .failure(let error):
                completion(.failure(getArtListServiceError(from: error)))
            }
        }
    }

    private func getArtListServiceError(from providerError: HTTPProviderError) -> ArtListServiceError {
        switch providerError {
        case .connection:
            return .connection
        case .invalidRequest, .invalidData, .undefined:
            return .undefined
        }
    }
}

// MARK: - ArtImage
extension ArtService: GetImageServiceProtocol {
    public func getArtImage(
        requestModel: ArtImageRequestModel,
        _ completion: @escaping (RemoteGetImageResult) -> Void
    ) {
        let getArtListTarget: ArtServiceTarget = .getImage(requestModel)

        provider.request(target: getArtListTarget) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                guard let data else {
                    return completion(.failure(.emptyData))
                }

                if data.isEmpty {
                    completion(.failure(.emptyData))
                } else {
                    completion(.success(.init(imageData: data)))
                }

            case .failure(let error):
                completion(.failure(getImageServiceError(from: error)))
            }
        }
    }

    private func getImageServiceError(from providerError: HTTPProviderError) -> GetImageServiceError {
        switch providerError {
        case .connection:
            return .connection
        case .invalidRequest, .invalidData, .undefined:
            return .undefined
        }
    }
}
