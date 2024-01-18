import Foundation
import ArtApp
import UIKit //

protocol ArtListViewModelProtocol {
    func fetchArtList()
}

protocol ArtListViewModelDelegate: AnyObject {
    func displayArtsList(with artItems: [ArtItemView])
    func updateArtImage(with artImage: ArtImageModel)
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
        artListUseCase.execute { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let data):
                DispatchQueue.main.sync { [delegate] in // TODO: Decorate Dispatch
                    var artItems: [ArtItemView] = []

                    data.artList.forEach {
                        artItems.append(ArtItemView(model: .init(
                            artId: $0.artId,
                            title: $0.title,
                            year: "\($0.year ?? 0)",
                            author: "\($0.author ?? "-")"
                        )))
                    }

                    delegate?.displayArtsList(with: artItems)
                }

                getImages(from: data.artList)

            case .failure(let error):
                print("\(error)")
            }
        }
    }

    private func getImages(from artList: ArtList) {
        var imagesRequestModel: GetArtImagesRequestModel = []

        artList.forEach {
            imagesRequestModel.append(.init(
                artId: $0.artId,
                imagedId: $0.imageId
            ))
        }

        getImageUseCase.execute(with: imagesRequestModel) { result in
            DispatchQueue.main.sync { [weak self] in // TODO: Decorate Dispatch
                guard let self else { return }

                switch result {
                case .success(let data):
                    delegate?.updateArtImage(with: .init(
                        artId: data.artId,
                        image: data.imageData
                    ))

                case .failure(let error):
                    delegate?.updateArtImage(with: .init(
                        artId: error.artId,
                        image: UIImage(systemName: "xmark.seal.fill")?.pngData() ?? Data()
                    ))
                    print("erro \(error.type)")
                }
            }
        }
    }
}
