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

    private func getArtListServiceError(from error: HTTPProviderError) -> ArtListServiceError {
        switch error {
        case .connection:
            return .connection
        case .invalidRequest, .invalidData, .undefined:
            return .undefined
        }
    }
}

// MARK: - Get Image
extension ArtService: GetImageServiceProtocol {
    public func getImage(
        requestModel: ArtImageRequestModel,
        _ completion: @escaping (RemoteGetImageResult) -> Void
    ) {

    }
}
