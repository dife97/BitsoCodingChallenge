import Foundation

// MARK: - Request
public struct ArtImageRequestModel {
    let imagedId: String
}

// MARK: - Response
public struct ArtImageResponse {
    let imageData: Data

    public init(imageData: Data) {
        self.imageData = imageData
    }
}
