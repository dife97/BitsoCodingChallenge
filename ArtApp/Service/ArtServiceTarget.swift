import ArtNetwork

public enum ArtServiceTarget {
    case getArtList(ArtListRequestModel)
}

extension ArtServiceTarget: ServiceTarget {
    public var method: HTTPMethod {
        .get
    }
    
    public var path: String {
        "artworks"
    }
    
    public var headers: [String : String] {
        [:]
    }
}
