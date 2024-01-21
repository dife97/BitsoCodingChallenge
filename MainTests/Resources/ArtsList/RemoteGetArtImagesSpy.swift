@testable import ArtApp

final class RemoteGetArtImagesSpy: GetArtImagesProtocol {
    func execute(
        with images: GetArtImagesRequestModel,
        completion: @escaping (GetArtImagesResult) -> Void
    ) {
        
    }
}

//final class RemoteGetArtImagesDummy: GetArtImagesProtocol {
//    var getArtImagesResultToReturn: GetArtImagesResult = .failure(.init(artId: 0, type: .connection))
//    func execute(
//        with images: GetArtImagesRequestModel,
//        completion: @escaping (GetArtImagesResult) -> Void
//    ) {
//
//    }
//}
