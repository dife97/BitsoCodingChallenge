public protocol LocalArtsListProtocol {
    func saveArtsList(
        model: ArtsList,
        completion: @escaping (ArtsListStoreError?) -> Void
    )

    func getArtsList(completion: @escaping (LocalArtsListResult) -> Void)
}

public typealias LocalArtsListResult = Result<ArtsList?, ArtsListStoreError>
