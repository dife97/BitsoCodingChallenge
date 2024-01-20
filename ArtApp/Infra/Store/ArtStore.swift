import ArtStore

final class ArtStore {
    private let provider: StoreProviderProtocol

    init(provider: StoreProviderProtocol) {
        self.provider = provider
    }
}
