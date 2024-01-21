public protocol ArtDetailsProtocol {
    func execute(
        model: ArtDetailsRequestModel,
        _ completion: @escaping (ArtDetailsResult) -> Void
    )
}

public typealias ArtDetailsResult = Result<ArtDetailsModel, ArtDetailsError>
