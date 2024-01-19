public final class RemoteArtDetailsUseCase: ArtDetailsProtocol {
    // MARK: Dependency
    private let service: ArtDetailsServiceProtocol

    // MARK: Initializer
    public init(service: ArtDetailsServiceProtocol) {
        self.service = service
    }

    // MARK: Public Method
    public func execute(
        model: ArtDetailsRequestModel,
        _ completion: @escaping (ArtDetailsResult) -> Void
    ) {
        service.getArtDetails(requestModel: model) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let artDetailsResponse):
                completion(.success(getArtDetailsModel(from: artDetailsResponse.data)))
            case .failure(let error):
                handleArtService(error, with: completion)
            }
        }
    }

    private func handleArtService(
        _ error: ArtServiceError,
        with completion: @escaping (ArtDetailsResult) -> Void
    ) {
        switch error {
        case .connection:
            completion(.failure(.connection))
        case .invalidData:
            completion(.failure(.invalidData))
        case .unexpected:
            completion(.failure(.unexpected))
        }
    }

    private func getArtDetailsModel(from responseData: ArtDetailsResponseData) -> ArtDetailsModel {
        .init(
            artId: responseData.artId,
            title: responseData.title,
            date: responseData.date,
            artistInfo: responseData.artistInfo,
            description: responseData.description,
            place: responseData.place,
            medium: responseData.medium,
            dimensions: responseData.dimensions
        )
    }
}
