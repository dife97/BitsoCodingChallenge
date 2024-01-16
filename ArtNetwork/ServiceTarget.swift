public protocol ServiceTarget {
    var server: ArtAPIServer { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var headers: [String: String] { get }
    var parameters: [String: Any]? { get }
}

public enum ArtAPIServer {
    case artAPI
    case iiifImageAPI
}

public enum HTTPMethod: String {
    case get = "GET"
}
