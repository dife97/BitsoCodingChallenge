import Foundation

protocol HTTPProvider {
    func request(
        target: ServiceTarget,
        completion: @escaping (Result<Data?, HTTPProviderError>) -> Void
    )
}

protocol ServiceTarget {
    var method: HTTPMethod { get }
    var path: String { get }
    var headers: [String: String] { get }
}

enum HTTPProviderError: Error {
    case invalidURL
}

enum HTTPMethod: String {
    case get = "GET"
}

final class URLSessionServiceProvider: HTTPProvider {
    private let session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    func request(
        target: ServiceTarget,
        completion: @escaping (Result<Data?, HTTPProviderError>) -> Void
    ) {
        guard let url = getURL(from: target.path) else {
            completion(.failure(.invalidURL)) // TODO: Add test
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = target.method.rawValue
        urlRequest.allHTTPHeaderFields = target.headers

        session.dataTask(with: urlRequest) { data, urlResponse, error in
            if error == nil {
                if let data {
                    // completion to be implemented

                } else {
                    // completion to be implemented
                }

            } else {
                // completion to be implemented
            }
        }.resume()
    }

    private func getURL(from path: String) -> URL? {
        let urlBaseString = "https://api.artic.edu/api/v1/"
        return .init(string: urlBaseString + path)
    }
}
