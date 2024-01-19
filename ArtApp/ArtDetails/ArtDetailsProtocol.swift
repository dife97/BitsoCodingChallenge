protocol ArtDetailsProtocol {
    func execute(
        model: ArtDetailsRequestModel,
        _ completion: @escaping (ArtDetailsResult) -> Void
    )
}

typealias ArtDetailsResult = Result<ArtDetailsModel, ArtDetailsError>
