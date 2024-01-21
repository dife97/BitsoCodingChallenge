import ArtStore

public final class ArtsListStore {
    private let provider: StoreProviderProtocol
    private let artsListPath = "arts-list"

    public init(provider: StoreProviderProtocol) {
        self.provider = provider
    }
}

extension ArtsListStore: LocalArtsListProtocol {
    public func saveArtsList(
        model: ArtsList,
        completion: @escaping (ArtsListStoreError?) -> Void
    ) {
        if model.isEmpty {
            return completion(.invalidRequest)
        }
        
        guard let modelData = model.toData() else { return }

        provider.insert(
            path: artsListPath,
            data: .init(data: modelData)
        ) { error in
            switch error {
            case .invalidRequest:
                completion(.invalidRequest)
            case .unexpected:
                completion(.unexpected)
            case nil:
                completion(nil)
            }
        }
    }

    public func getArtsList(completion: @escaping (LocalArtsListResult) -> Void) {
        provider.retrieve(path: artsListPath) { [weak self] result in
            guard let self else { return }

            switch result {
            case .empty:
                completion(.success(nil))
            case .retrievedData(let cacheDataModel):
                if let artsList: ArtsList = cacheDataModel.data.toModel() {
                    completion(.success(artsList))
                } else {
                    completion(.failure(.unexpected))
                }

            case .error(let storeProviderError):
                completion(.failure(getArtStoreError(from: storeProviderError)))
            }
        }
    }

//    public func cleanArtsList(completion: @escaping (ArtsListStoreError?) -> Void) {
//        provider.delete(path: artsListPath) { error in
//            switch error {
//            case .invalidRequest:
//                completion(.invalidRequest)
//            case .unexpected:
//                completion(.unexpected)
//            case nil:
//                completion(nil)
//            }
//        }
//    }
}

// MARK: - Private Methods
extension ArtsListStore {
    private func getArtStoreError(from error: StoreProviderError) -> ArtsListStoreError {
        switch error {
        case .invalidRequest:
            return .invalidRequest
        case .unexpected:
            return .unexpected
        }
    }
}
