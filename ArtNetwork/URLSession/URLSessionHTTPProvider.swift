import Foundation

public final class URLSessionHTTPProvider: HTTPProvider {
    private let session: URLSession

    public init(session: URLSession) {
        self.session = session
    }

    public func request(
        target: ServiceTarget,
        completion: @escaping (Result<Data?, HTTPProviderError>) -> Void
    ) {
        guard let url = getURL(from: target.path) else {
            return completion(.failure(.invalidRequest))
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = target.method.rawValue
        urlRequest.allHTTPHeaderFields = target.headers

        session.dataTask(with: urlRequest) { data, urlResponse, error in
            if error == nil {
                guard let httpURLResponse = urlResponse as? HTTPURLResponse else {
                    return completion(.failure(.undefined))
                }
                switch httpURLResponse.statusCode {
                case 200...299:
                    completion(.success(data))
                default:
                    completion(.failure(.undefined))
                }
            } else {
                completion(.failure(.connection))
            }
        }.resume()
    }

    private func getURL(from path: String) -> URL? {
        let urlBaseString = "https://api.artic.edu/api/v1/"
        return .init(string: urlBaseString + path)
    }
}
