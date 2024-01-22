import ArtStore

final class StoreProviderSpy: StoreProviderProtocol {
    private(set) var receivedInsertPath: [String] = []
    private(set) var receivedInsertCompletion: [(StoreProviderError?) -> Void] = []
    func insert(
        path: String,
        data: CacheDataModel,
        completion: @escaping (StoreProviderError?) -> Void
    ) {
        receivedInsertPath.append(path)
        receivedInsertCompletion.append(completion)
    }

    func completeInsert(
        with error: StoreProviderError?,
        atIndex index: Int = 0
    ) {
        receivedInsertCompletion[index](error)
    }

    private(set) var receivedRetrievePath: [String] = []
    private(set) var receivedRetrieveCompletion: [(RetriveResult) -> Void] = []
    func retrieve(
        path: String,
        completion: @escaping (RetriveResult) -> Void
    ) {
        receivedRetrievePath.append(path)
        receivedRetrieveCompletion.append(completion)
    }

    func completeRetrieve(
        with result: RetriveResult,
        atIndex index: Int = 0
    ) {
        receivedRetrieveCompletion[index](result)
    }

    private(set) var receivedDeletePath: [String] = []
    private(set) var receivedDeleteCompletion: [(StoreProviderError?) -> Void] = []
    func delete(
        path: String,
        completion: @escaping (StoreProviderError?) -> Void
    ) {
        receivedDeletePath.append(path)
        receivedDeleteCompletion.append(completion)
    }

    func completeDelete(
        with error: StoreProviderError?,
        atIndex index: Int = 0
    ) {
        receivedDeleteCompletion[index](error)
    }
}
