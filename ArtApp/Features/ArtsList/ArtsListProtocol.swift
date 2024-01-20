public protocol ArtsListProtocol {
    func execute(
        isRefreshing: Bool,
        _ completion: @escaping (ArtsListResult) -> Void
    )
}

public typealias ArtsListResult = Result<ArtsListModel, ArtsListError>
