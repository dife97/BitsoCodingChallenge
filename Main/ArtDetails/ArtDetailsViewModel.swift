import ArtApp

protocol ArtDetailsViewModelProtocol {
    func didTapArtItem(with artId: Int)
}

final class ArtDetailsViewModel: ArtDetailsViewModelProtocol {
    // MARK: - Dependency
    private let getArtDetailsUseCase: ArtDetailsProtocol

    // MARK: - Initializer
    init(getArtDetailsUseCase: ArtDetailsProtocol) {
        self.getArtDetailsUseCase = getArtDetailsUseCase
    }

    // MARK: - Public Method
    func didTapArtItem(with artId: Int) {
        getArtDetailsUseCase.execute(model: .init(artId: artId)) { result in
            switch result {
            case .success(let data):
                print("SUCCESS")
                print(data)

            case .failure(let error):
                print("FAIL: \(error)")
            }
        }
    }
}
