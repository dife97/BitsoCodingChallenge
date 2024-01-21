import Foundation

// MARK: - Request
public struct ArtImageRequestModel {
    let imagedId: String

    init(imagedId: String) {
        self.imagedId = imagedId
    }
}

// MARK: - Response
public struct ArtImageResponse: EquatableModel {
    let imageData: Data

    init(imageData: Data) {
        self.imageData = imageData
    }
}
