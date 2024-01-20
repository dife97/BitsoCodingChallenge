import Foundation

final class FileManagerStoreProvider: StoreProviderProtocol {
    // MARK: - Dependency
    private let manager: FileManager

    // MARK: - Initializer
    init(manager: FileManager = .default) {
        self.manager = manager
    }

    // MARK: - Public Methods
    func insert(
        target: StoreTarget,
        data: CacheDataModel,
        completion: @escaping (StoreProviderError?) -> Void
    ) {
        guard let url = getURL(from: target.path) else {
            return completion(.invalidRequest)
        }

        do {
            try data.data.write(to: url)
            completion(nil)
        } catch {
            completion(.unexpected)
        }
    }

    func retrieve(
        target: StoreTarget,
        completion: @escaping (RetriveResult) -> Void
    ) {
        guard let url = getURL(from: target.path) else {
            return completion(.error(.invalidRequest))
        }

        guard let data = try? Data(contentsOf: url) else {
            return completion(.empty)
        }

        if let cachedData = try? JSONDecoder().decode(CacheDataModel.self, from: data) {
            completion(.retrievedData(cachedData))
        } else {
            completion(.error(.unexpected))
        }
    }

    func delete(
        target: StoreTarget,
        completion: @escaping (StoreProviderError?) -> Void
    ) {
        guard let url = getURL(from: target.path) else {
            return completion(.invalidRequest)
        }

        do {
            try manager.removeItem(at: url)
            completion(nil)
        } catch {
            return completion(.unexpected)
        }
    }

    // MARK: - Private Methods
    private func getURL(from path: String) -> URL? {
        manager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first?.appendingPathComponent("\(path).store")
    }
}
