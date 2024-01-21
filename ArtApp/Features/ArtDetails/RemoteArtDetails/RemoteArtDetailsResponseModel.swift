public struct ArtDetailsResponseModel: EquatableModel {
    let data: ArtDetailsResponseData
}

public struct ArtDetailsResponseData: EquatableModel {
    let artId: Int
    let description: String?
    let place: String?
    let date: String?
    let medium: String?
    let inscriptions: String?
    let dimensions: String?
    let creditLine: String?
    let referenceNumber: String?

    enum CodingKeys: String, CodingKey {
        case description, dimensions, inscriptions
        case artId = "id"
        case date = "date_display"
        case place = "place_of_origin"
        case medium = "medium_display"
        case referenceNumber = "main_reference_number"
        case creditLine = "credit_line"
    }
}
