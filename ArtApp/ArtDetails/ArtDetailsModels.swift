// MARK: - Request
public struct ArtDetailsRequestModel: EquatableModel {
    let artId: Int

    public init(artId: Int) {
        self.artId = artId
    }
}

// MARK: - Response
public struct ArtDetailsModel: EquatableModel {
    public let artId: Int
    public let title: String
    public let date: String
    public let artistInfo: String
    public let description: String
    public let place: String
    public let medium: String
    public let dimensions: String
}
