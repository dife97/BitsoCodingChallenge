import Foundation
import ArtApp

protocol ArtListViewModelProtocol {
    func fetchArtList()
}

protocol ArtListViewModelDelegate: AnyObject {
    func updateImage(with imageData: Data)
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
        print("Will Fetch")
        artListUseCase.execute { result in
            switch result {
            case .success(let data):
                print("SUCCESS: 😎")

                let imageToGet = data.artList.first
                self.temporaryGetImage(from: imageToGet)

            case .failure(let error):
                print("FAILURE: ❌")
                print("\(error)")
            }
        }
    }

    private func temporaryGetImage(from artModel: ArtModel?) {
        guard let artModel else { return }

        let imagesRequestModel: GetArtImagesRequestModel = [
            .init(artId: artModel.artId, imagedId: artModel.imageId)
        ]
        getImageUseCase.execute(with: imagesRequestModel) { result in
            switch result {
            case .success(let data):
                print("SUCCESS: 😎")
                self.delegate?.updateImage(with: data.imageData)

            case .failure(let error):
                print("FAILURE: ❌")
                print("\(error.type)")
            }
        }
    }
}
