import ArtNetwork

enum ArtServiceTarget {
    case getArtList(ArtsListRequestModel)
    case getArtImage(ArtImageRequestModel)
    case getArtDetails(ArtDetailsRequestModel)
}

extension ArtServiceTarget: ServiceTarget {
    var server: ArtAPIServer {
        switch self {
        case .getArtList, .getArtDetails:
            return .artAPI
        case .getArtImage:
            return .iiifImageAPI
        }
    }

    var method: HTTPMethod { .get }

    var path: String {
        switch self {
        case .getArtList:
            return "artworks"
        case .getArtImage(let model):
            return "\(model.imagedId)/full/400,/0/default.jpg" // TODO: Document why using 200 (time and avoid images that does not have this full
        case .getArtDetails(let model):
            return "artworks/\(model.artId)"
        }
    }

    var headers: [String : String] {
        [
            "AIC-User-Agent" : "BitsoCodingChallenge (diferodrigues@gmail.com)"
        ]
    }

    var parameters: [String : Any]? {
        switch self {
        case .getArtList(let artListRequestModel):
            return getArtListParameters(from: artListRequestModel)
        case .getArtImage:
            return nil
        case .getArtDetails:
            return getArtDetailsParameters()
        }
    }
}

// MARK: - Private Methods
extension ArtServiceTarget {
    private func getArtListParameters(from requestModel: ArtsListRequestModel) -> [String: Any] {
        [
            "page": requestModel.page,
            "limit": requestModel.limit,
            "fields": [
                "id",
                "image_id",
                "title",
                "date_start", // TODO: Change to date_display
                "artist_title"
            ].joined(separator: ",")
        ]
    }

    private func getArtDetailsParameters() -> [String: Any] {
        [
            "fields": [
                "id",
                "title",
                "date_display",
                "artist_display",
                "description",
                "place_of_origin",
                "medium_display",
                "dimensions",
            ].joined(separator: ",")
        ]
    }
}
