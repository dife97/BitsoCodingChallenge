import Foundation

public protocol HTTPProvider {
    func request(
        target: ServiceTarget,
        completion: @escaping (HTTPProviderResult) -> Void
    )
}

public typealias HTTPProviderResult = Result<Data?, HTTPProviderError>
