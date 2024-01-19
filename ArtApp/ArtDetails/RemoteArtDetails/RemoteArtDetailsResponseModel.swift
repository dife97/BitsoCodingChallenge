struct ArtDetailsResponseModel: EquatableModel {
    let data: ArtDetailsResponseData
}

struct ArtDetailsResponseData: EquatableModel {
    let artId: String
    let title: String
    let date: String
    let artistInfo: String
    let description: String
    let place: String
    let medium: String
    let dimensions: String

    enum CodingKeys: String, CodingKey {
        case title, description, dimensions
        case artId = "id"
        case date = "date_display"
        case artistInfo = "artist_display"
        case place = "place_of_origin"
        case medium = "medium_display"
    }
}
