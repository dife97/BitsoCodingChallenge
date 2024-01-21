public final class ArtsListManager: ArtsListProtocol {
    // MARK: - Properties
    private var isFetching = false
    private var isRefreshing = false
    private var currentPage = 1
    private var isFirstPage: Bool { currentPage == 1 }
    private let limitPerPage = 10

    // MARK: - Dependencies
    private let remoteArtsList: RemoteArtsListProtocol
    private let localArtsList: LocalArtsListProtocol

    // MARK: - Initializer
    public init(
        remoteArtsList: RemoteArtsListProtocol,
        localArtsList: LocalArtsListProtocol
    ) {
        self.remoteArtsList = remoteArtsList
        self.localArtsList = localArtsList
    }

    // MARK: - Public Method
    public func getArtsList(
        isRefreshing: Bool,
        completion: @escaping (ArtsListResult) -> Void
    ) {
        if isFetching {
            return completion(.failure(.isFetching))
        }

        self.isRefreshing = isRefreshing

        if isRefreshing {
            currentPage = 1
        }

        isFetching = true

        let requestModel: ArtsListRequestModel = .init(
            page: currentPage,
            limit: limitPerPage
        )

        remoteArtsList.getArtsList(requestModel: requestModel) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let artsListResponse):
                Logger.log("Fetched remote ArtsList successfully.")
                let artsList = getArtsList(from: artsListResponse.data)
                completion(.success(artsList))
                checkToSaveArtsList(artsList)

            case .failure(let error):
                Logger.log("Failed to fetch ArtsList remotely. Error: \(error)")
                handleArtServiceError(error, completion: completion)
            }

            self.isRefreshing = false
            isFetching = false
            currentPage += 1
        }
    }

    private func getArtsList(from artListData: [ArtListData]) -> ArtsList {
        artListData.map {
            .init(
                artId: $0.artId,
                imageId: $0.imageId,
                title: $0.title,
                year: $0.year,
                author: $0.author
            )
        }
    }

    private func checkToSaveArtsList(_ artsList: ArtsList) {
        if currentPage == 1 { // TODO: Add unit test
            localArtsList.saveArtsList(model: artsList) { error in
                if let error {
                    Logger.log("Failed to save ArtsList locally. Error: \(error)")
                } else {
                    Logger.log("Saved ArtsList locally.")
                }
            }
        }
    }

    private func handleArtServiceError(
        _ error: ArtServiceError,
        completion: @escaping (ArtsListResult) -> Void
    ) {
        // TODO: Add guard

        if isRefreshing && isFirstPage {
            completion(.failure(.connection))
        }

        if isFirstPage {
            // TODO: Move to private method
            localArtsList.getArtsList { result in
                switch result {
                case .success(let artsList):
                    guard let artsList, !artsList.isEmpty else {
                        Logger.log("Failed to fetch ArtsList locally. Error: empty")
                        return completion(.failure(.unexpected))
                    }
                    Logger.log("Fetched local ArtsList successfully.")
                    completion(.success(artsList))

                case .failure(let storeError):
                    Logger.log("Failed to fetch ArtsList locally. Error: \(storeError)")
                    completion(.failure(self.getArtsListError(from: error)))
                }
            }
        }
    }

    private func getArtsListError(from error: ArtServiceError) -> ArtsListError {
        switch error {
        case .connection:
            return .connection
        case .invalidData, .unexpected:
            return .unexpected
        }
    }
}
