protocol ArtListProtocol {
    func execute(_ completion: @escaping (ArtListResult) -> Void)
}

typealias ArtListResult = Result<ArtListModel, ArtListError>

enum ArtListError: Error {}
