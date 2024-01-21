import Foundation

// MARK: - Request
public typealias GetArtImagesRequestModel = [GetArtImageRequestModel]

public struct GetArtImageRequestModel {
    let artId: Int
    let imagedId: String?

    public init(
        artId: Int,
        imagedId: String?
    ) {
        self.artId = artId
        self.imagedId = imagedId
    }
}

// MARK: - Response
public struct ArtImage {
    public let artId: Int
    public let imageData: Data
}
