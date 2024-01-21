import ArtNetwork

extension ArtService: RemoteArtsListProtocol {
    public func getArtsList(
        requestModel: ArtsListRequestModel,
        completion: @escaping (RemoteArtListResult) -> Void
    ) {
        let getArtListTarget: ArtServiceTarget = .getArtList(requestModel)

        provider.request(target: getArtListTarget) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let data):
                if let model: ArtsListResponseModel = data?.toModel() {
                    completion(.success(model))
                } else {
                    completion(.failure(.invalidData))
                }

            case .failure(let error):
                completion(.failure(getArtListServiceError(from: error)))
            }
        }
    }

    private func getArtListServiceError(from providerError: HTTPProviderError) -> ArtServiceError {
        switch providerError {
        case .connection:
            return .connection
        case .invalidRequest, .invalidData, .unexpected:
            return .unexpected
        }
    }
}
