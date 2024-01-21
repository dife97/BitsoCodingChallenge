import Foundation

public protocol StoreProviderProtocol {
    func insert(
        path: String,
        data: CacheDataModel,
        completion: @escaping (StoreProviderError?) -> Void
    )

    func retrieve(
        path: String,
        completion: @escaping (RetriveResult) -> Void
    )
}

public enum RetriveResult {
    case empty
    case retrievedData(CacheDataModel)
    case error(StoreProviderError)
}

public struct CacheDataModel: Codable {
    public let data: Data
    public let timestamp: Date

    public init(
        data: Data,
        timestamp: Date = Date()
    ) {
        self.data = data
        self.timestamp = timestamp
    }
}
