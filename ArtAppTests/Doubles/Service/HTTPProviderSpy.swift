import ArtNetwork

final class HTTPProviderSpy: HTTPProviderProtocol {
    private(set) var receivedTarget: ServiceTarget?
    private var receivedCompletion: [(HTTPProviderResult) -> Void] = []

    func request(
        target: ServiceTarget,
        completion: @escaping (HTTPProviderResult) -> Void
    ) {
        receivedTarget = target
        receivedCompletion.append(completion)
    }

    func complete(with result: HTTPProviderResult) {
        receivedCompletion.first?(result)
    }
}
