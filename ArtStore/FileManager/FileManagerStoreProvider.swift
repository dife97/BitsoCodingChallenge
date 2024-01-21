import Foundation

public final class FileManagerStoreProvider: StoreProviderProtocol {
    // MARK: - Dependency
    private let manager: FileManager

    // MARK: - Initializer
    public init(manager: FileManager = .default) {
        self.manager = manager
    }

    // MARK: - Public Methods
    public func insert(
        path: String,
        data: CacheDataModel,
        completion: @escaping (StoreProviderError?) -> Void
    ) {
        guard 
            let url = getURL(from: path),
            let encodedData = try? JSONEncoder().encode(data)
        else {
            return completion(.invalidRequest)
        }

        do {
            try encodedData.write(to: url)
            completion(nil)
        } catch {
            completion(.unexpected)
        }
    }

    public func retrieve(
        path: String,
        completion: @escaping (RetriveResult) -> Void
    ) {
        guard let url = getURL(from: path) else {
            return completion(.error(.invalidRequest))
        }

        guard let data = try? Data(contentsOf: url) else {
            return completion(.empty)
        }

        // String(data: data, encoding: .utf8)

        if let cachedData = try? JSONDecoder().decode(CacheDataModel.self, from: data) {
            completion(.retrievedData(cachedData))
        } else {
            completion(.error(.unexpected))
        }
    }

//    public func delete(
//        path: String,
//        completion: @escaping (StoreProviderError?) -> Void
//    ) {
//        guard let url = getURL(from: path) else {
//            return completion(.invalidRequest)
//        }
//
//        do {
//            try manager.removeItem(at: url)
//            completion(nil)
//        } catch {
//            return completion(.unexpected)
//        }
//    }

    // MARK: - Private Methods
    private func getURL(from path: String) -> URL? {
        manager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first?.appendingPathComponent("\(path).store")
    }
}
