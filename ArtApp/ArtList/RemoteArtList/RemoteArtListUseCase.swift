public final class RemoteArtListUseCase: ArtListProtocol {
    // MARK: - Properties
    private var isFetching = false
    private var currentPage = 1
    private let limit = 10

    // MARK: - Initializer
    private let service: RemoteArtListProtocol

    public init(service: RemoteArtListProtocol) {
        self.service = service
    }

    // MARK: - Public Method
    public func execute(_ completion: @escaping (ArtListResult) -> Void) {
        if isFetching {
            return completion(.failure(.isFetching))
        }

        isFetching = true

        let requestModel: ArtListRequestModel = .init(
            page: currentPage, 
            limit: limit
        )
        
        service.getArtList(requestModel: requestModel) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let artListResponse):
                completion(.success(getArtListModel(from: artListResponse.data)))

            case .failure(let error):
                handleGetArtList(error, with: completion)
            }

            isFetching = false
            currentPage += 1
        }
    }
}

// MARK: - Private Methods
extension RemoteArtListUseCase {
    private func handleGetArtList(
        _ error: HTTPError,
        with completion: @escaping (ArtListResult) -> Void
    ) {
        switch error {
        case .noConnection:
            completion(.failure(.connection))
        case .invalidData:
            completion(.failure(.dataParsing))
        }
    }

    private func getArtListModel(from reponseData: [ArtListData]) -> ArtListModel {
        .init(artList: reponseData.map({
            .init(
                id: $0.id,
                imageId: $0.imageId,
                title: $0.title,
                year: $0.year,
                author: $0.author
            )
        }))
    }
}