import Foundation

public protocol HTTPProviderProtocol {
    func request(
        target: ServiceTarget,
        completion: @escaping (HTTPProviderResult) -> Void
    )
}

public typealias HTTPProviderResult = Result<Data?, HTTPProviderError>
