import Foundation

// MARK: - Request
public struct ArtImageRequestModel {
    let imagedId: String

    public init(imagedId: String) {
        self.imagedId = imagedId
    }
}

// MARK: - Response
public struct ArtImageResponse: EquatableModel {
    let imageData: Data

    public init(imageData: Data) {
        self.imageData = imageData
    }
}
