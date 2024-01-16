public protocol RemoteArtListProtocol {
    func getArtList(
        requestModel: ArtListRequestModel,
        _ completion: @escaping (RemoteArtListResult) -> Void
    )
}

public typealias RemoteArtListResult = Result<ArtListResponseModel, HTTPError>

public final class RemoteArtListUseCase: ArtListProtocol {
    private let service: RemoteArtListProtocol

    public init(service: RemoteArtListProtocol) {
        self.service = service
    }

    public func execute(_ completion: @escaping (ArtListResult) -> Void) {
        let requestModel: ArtListRequestModel = .init(
            page: 1, limit: 10
        )
        
        service.getArtList(requestModel: requestModel) { result in

        }
    }
}
