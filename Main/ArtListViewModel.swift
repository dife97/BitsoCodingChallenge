import ArtApp

protocol ArtListViewModelProtocol {
    func fetchArtList()
}

final class ArtListViewModel: ArtListViewModelProtocol {
    // MARK: - Dependency
    private let artListUseCase: ArtListProtocol

    // MARK: - Initializer
    init(artListUseCase: ArtListProtocol) {
        self.artListUseCase = artListUseCase
    }

    // MARK: - Public Methods
    func fetchArtList() {
        print("Will Fetch")
        artListUseCase.execute { result in
            switch result {
            case .success(let data):
                print("SUCCESS: 😎")
                data.artList.forEach { artModel in
                    print("\(artModel.title) - \(artModel.author ?? "No Author") (\(artModel.year))")
                }
            case .failure(let error):
                print("FAILURE: ❌")
                print("\(error)")
            }
        }
    }
}
