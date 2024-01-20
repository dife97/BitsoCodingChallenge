public protocol ArtsListStoreProtocol {
    func saveArtsList(
        model: ArtList,
        completion: @escaping (ArtStoreError?) -> Void
    )

    func getArtsList(completion: @escaping (LocalArtsListResult) -> Void)

    func cleanArtsList(completion: @escaping (ArtStoreError?) -> Void)
}

public typealias LocalArtsListResult = Result<ArtList?, ArtStoreError>
