import ArtNetwork

public enum ArtServiceTarget {
    case getArtList(ArtListRequestModel)
    case getArtImage(ArtImageRequestModel)
}

extension ArtServiceTarget: ServiceTarget {
    public var server: ArtAPIServer {
        switch self {
        case .getArtList:
            return .artAPI
        case .getArtImage:
            return .iiifImageAPI
        }
    }

    public var method: HTTPMethod {
        .get
    }

    public var path: String {
        switch self {
        case .getArtList:
            return "artworks"
        case .getArtImage(let requestModel):
            return "\(requestModel.imagedId)/full/200,/0/default.jpg" // TODO: Document why using 200 (time and avoid images that does not have this full
        }
    }

    public var headers: [String : String] {
        [
            "AIC-User-Agent" : "BitsoCodingChallenge (diferodrigues@gmail.com)"

        ]
    }

    public var parameters: [String : Any]? {
        switch self {
        case .getArtList(let artListRequestModel):
            return getArtListParameters(from: artListRequestModel)
        case .getArtImage:
            return nil
        }
    }
}

// MARK: - Private Methods
extension ArtServiceTarget {
    private func getArtListParameters(from requestModel: ArtListRequestModel) -> [String: Any] {
        [
            "page": requestModel.page,
            "limit": requestModel.limit,
            "fields": [
                "id",
                "image_id",
                "title",
                "date_start",
                "artist_title"
            ].joined(separator: ",")
        ]
    }
}
