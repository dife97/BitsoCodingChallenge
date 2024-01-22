@testable import ArtApp

final class RemoteGetArtImagesSpy: GetArtImagesProtocol {
    func execute(
        with images: GetArtImagesRequestModel,
        completion: @escaping (GetArtImagesResult) -> Void
    ) {}
}
