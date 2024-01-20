import Foundation

public final class URLSessionHTTPProvider: HTTPProvider {
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func request(
        target: ServiceTarget,
        completion: @escaping (Result<Data?, HTTPProviderError>) -> Void
    ) {
        if let url = getURL(
            from: target.server,
            path: target.path,
            parameters: target.parameters
        ) {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = target.method.rawValue
            urlRequest.allHTTPHeaderFields = target.headers

            session.dataTask(with: urlRequest) { data, urlResponse, error in
                if error == nil {
                    guard let httpURLResponse = urlResponse as? HTTPURLResponse else {
                        return completion(.failure(.unexpected))
                    }
                    switch httpURLResponse.statusCode {
                    case 200...299:
                        completion(.success(data))
                    default:
                        completion(.failure(.unexpected))
                    }
                } else {
                    completion(.failure(.connection))
                }
            }.resume()
        } else {
            completion(.failure(.invalidRequest))
        }
    }

    private func getURL(
        from server: ArtAPIServer,
        path: String,
        parameters: [String: Any]?
    ) -> URL? {
        var urlComponents = URLComponents(string: server.urlBaseString + path)

        if let parameters {
            var queryItems: [URLQueryItem] = []

            parameters.forEach({ key, value in
                let valueString = "\(value)"
                let encodedValue = valueString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                let queryItem = URLQueryItem(
                    name: key,
                    value: encodedValue ?? valueString
                )
                queryItems.append(queryItem)
            })

            urlComponents?.queryItems = queryItems
        }

        return urlComponents?.url
    }
}
