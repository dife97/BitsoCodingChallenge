final class ArtService {
    private let provider: HTTPProvider

    init(provider: HTTPProvider) {
        self.provider = provider
    }
}

// MARK: - Art List
extension ArtService: RemoteArtListProtocol {
    func getArtList(
        requestModel: ArtListRequestModel,
        _ completion: @escaping (RemoteArtListResult) -> Void
    ) {

    }
}
