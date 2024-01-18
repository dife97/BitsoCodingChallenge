public protocol ArtListProtocol {
    func execute(
        isRefreshing: Bool,
        _ completion: @escaping (ArtListResult) -> Void
    )
}

public typealias ArtListResult = Result<ArtListModel, ArtListError>
