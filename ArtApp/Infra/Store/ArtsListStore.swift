import ArtStore

public final class ArtsListStore {
    let provider: StoreProviderProtocol
    let artsListPath = "arts-list"

    public init(provider: StoreProviderProtocol) {
        self.provider = provider
    }
}
