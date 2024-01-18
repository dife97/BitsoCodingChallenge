import Foundation
import ArtApp

protocol ArtListViewModelProtocol {
    func fetchArtList()
}

protocol ArtListViewModelDelegate: AnyObject {
    func displayArtsList(with artItems: ArtItemViews)
}

final class ArtListViewModel: ArtListViewModelProtocol {
    // MARK: - Dependency
    private let artListUseCase: ArtListProtocol
    private let getImageUseCase: GetArtImagesProtocol
    weak var delegate: ArtListViewModelDelegate?

    // MARK: - Initializer
    init(
        artListUseCase: ArtListProtocol,
        getImageUseCase: GetArtImagesProtocol
    ) {
        self.artListUseCase = artListUseCase
        self.getImageUseCase = getImageUseCase
    }

    // MARK: - Public Methods
    func fetchArtList() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
            let artItems: ArtItemViews = [
                ArtItemView(model: .init(title: "Title", year: "2009", author: "Diego Ferreira")),
                ArtItemView(model: .init(title: "Title Title", year: "2009", author: "Diego Ferreira")),
                ArtItemView(model: .init(title: "Title Title Title Title Title Title", year: "2009", author: "Diego Ferreira")),
            ]
            delegate?.displayArtsList(with: artItems)
        }
    }

    private func temporaryGetImage(from artModel: ArtModel?) {
        guard let artModel else { return }

        let imagesRequestModel: GetArtImagesRequestModel = [
            .init(artId: artModel.artId, imagedId: artModel.imageId)
        ]
        getImageUseCase.execute(with: imagesRequestModel) { result in
            switch result {
            case .success(_):
                print("SUCCESS: 😎")

            case .failure(let error):
                print("FAILURE: ❌")
                print("\(error.type)")
            }
        }
    }
}
