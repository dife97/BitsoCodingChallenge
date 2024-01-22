import ArtNetwork

public final class ArtService {
    let provider: HTTPProviderProtocol

    public init(provider: HTTPProviderProtocol) {
        self.provider = provider
    }
}
