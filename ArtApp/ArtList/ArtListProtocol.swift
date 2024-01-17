public protocol ArtListProtocol {
    func execute(_ completion: @escaping (ArtListResult) -> Void)
}

public typealias ArtListResult = Result<ArtListModel, ArtListError>
