protocol ArtsListStoreProtocol {
    func saveArtsList(
        model: ArtList
    )

    func getArtsList(completion: @escaping (ArtStoreError?) -> Void)

    func cleanArtsList(completion: @escaping (ArtStoreError?) -> Void)
}
