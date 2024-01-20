import Foundation

// TODO: Segregate
public protocol StoreProviderProtocol {
    func insert(
        target: StoreTarget,
        data: CacheDataModel,
        completion: @escaping (StoreProviderError?) -> Void
    )

    func retrieve(
        target: StoreTarget,
        completion: @escaping (RetriveResult) -> Void
    )

    func delete(
        target: StoreTarget,
        completion: @escaping (StoreProviderError?) -> Void
    )
}

public enum RetriveResult {
    case empty
    case retrievedData(CacheDataModel)
    case error(StoreProviderError)
}

public struct CacheDataModel: Decodable {
    let data: Data
    let timestamp: Date
}
