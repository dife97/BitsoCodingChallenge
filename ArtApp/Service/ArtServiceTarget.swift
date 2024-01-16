import ArtNetwork

public enum ArtServiceTarget {
    case getArtList(ArtListRequestModel)
}

extension ArtServiceTarget: ServiceTarget {
    public var server: ArtAPIServer {
        switch self {
        case .getArtList(let artListRequestModel):
            return .artAPI
        }
    }

    public var method: HTTPMethod {
        .get
    }

    public var path: String {
        switch self {
        case .getArtList:
            return "artworks"
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
            ]
        ]
    }
}
