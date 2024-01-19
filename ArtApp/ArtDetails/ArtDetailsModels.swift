// MARK: - Request
public struct ArtDetailsRequestModel: EquatableModel {
    let artId: Int
}

// MARK: - Response
struct ArtDetailsModel: EquatableModel {
    let artId: String
    let title: String
    let date: String
    let artistInfo: String
    let description: String
    let place: String
    let medium: String
    let dimensions: String
}
