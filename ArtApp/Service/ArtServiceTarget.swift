enum ArtServiceTarget {
    case getArtList(ArtListRequestModel)
}

extension ArtServiceTarget: ServiceTarget {
    var method: HTTPMethod {
        .get
    }
    
    var path: String {
        "artworks"
    }
    
    var headers: [String : String] {
        [:]
    }
}
