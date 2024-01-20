public protocol GetArtImagesProtocol {
    func execute(
        with images: GetArtImagesRequestModel,
        _ completion: @escaping (GetArtImagesResult) -> Void
    )
}

public typealias GetArtImagesResult = Result<ArtImage, ArtImageError>
