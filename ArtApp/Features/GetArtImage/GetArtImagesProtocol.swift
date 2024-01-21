public protocol GetArtImagesProtocol {
    func execute(
        with images: GetArtImagesRequestModel,
        completion: @escaping (GetArtImagesResult) -> Void
    )
}

public typealias GetArtImagesResult = Result<ArtImage, ArtImageError>
