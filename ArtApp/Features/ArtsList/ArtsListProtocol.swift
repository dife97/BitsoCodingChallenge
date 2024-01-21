public protocol ArtsListProtocol {
    func getArtsList(
        isRefreshing: Bool,
        completion: @escaping (ArtsListResult) -> Void
    )
}

public typealias ArtsListResult = Result<ArtsList, ArtsListError>
