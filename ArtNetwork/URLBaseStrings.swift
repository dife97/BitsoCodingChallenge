extension ArtAPIServer {
    var urlBaseString: String {
        switch self {
        case .artAPI:
            return "https://api.artic.edu/api/v1/"
        case .iiifImageAPI:
            return "https://www.artic.edu/iiif/2/"
        }
    }
}
