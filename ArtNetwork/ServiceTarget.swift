public protocol ServiceTarget {
    var method: HTTPMethod { get }
    var path: String { get }
    var headers: [String: String] { get }
}

public enum HTTPMethod: String {
    case get = "GET"
}
