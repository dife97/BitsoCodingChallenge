import Foundation
import ArtApp
import UIKit

protocol ArtListViewModelProtocol {
    func fetchArtList()
    func prefetchNextPage()
    func refreshArtsList()
}

protocol ArtListViewModelDelegate: AnyObject {
    func displayArtsList(with artItems: [ArtItemView])
    func displayPrefetchedArtsList(with prefetchedArtItems: [ArtItemView])
    func refreshArtsList(with refreshedArtItems: [ArtItemView])
    func updateArtImage(with artImage: ArtImageModel)
}

final class ArtListViewModel: ArtListViewModelProtocol {
    // MARK: - Dependency
    private let useCases: UseCases
    weak var delegate: ArtListViewModelDelegate?

    // MARK: - Inner Type
    struct UseCases {
        let getArtsList: ArtListProtocol
        let getArtImage: GetArtImagesProtocol
        let getArtDetails: ArtDetailsProtocol
    }

    // MARK: - Initializer
    init(useCases: UseCases) {
        self.useCases = useCases
    }

    // MARK: - Public Methods
    func fetchArtList() {
        getArtsList { [delegate] result in
            switch result {
            case .success(let artItems):
                delegate?.displayArtsList(with: artItems)

            case .failure(let error):
                print("\(error)")
            }
        }
    }

    func prefetchNextPage() {
        getArtsList { [delegate] result in
            switch result {
            case .success(let artItems):
                delegate?.displayPrefetchedArtsList(with: artItems)

            case .failure(let error):
                print("\(error)")
            }
        }
    }

    func refreshArtsList() {
        getArtsList(isRefreshing: true) { [delegate] result in
            switch result {
            case .success(let artItems):
                delegate?.refreshArtsList(with: artItems)

            case .failure(let error):
                print("\(error)")
            }
        }
    }
}

// MARK: - Private Methods
extension ArtListViewModel {
    private func getArtsList(
        isRefreshing: Bool = false,
        _ completion: @escaping (Result<[ArtItemView], ArtListError>) -> Void
    ) {
        useCases.getArtsList.execute(isRefreshing: isRefreshing) { result in
            DispatchQueue.main.async { [weak self] in // TODO: Decorate Dispatch
                guard let self else { return }

                switch result {
                case .success(let data):
                    var artItems: [ArtItemView] = []
                    data.artList.forEach {
                        artItems.append(ArtItemView(model: .init(
                            artId: $0.artId,
                            title: $0.title,
                            year: "\($0.year ?? 0)",
                            author: "\($0.author ?? "-")"
                        )))
                    }
                    completion(.success(artItems))
                    getImages(from: data.artList)

                case .failure(let error):
                    completion(.failure(error))
                }
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

        useCases.getArtImage.execute(with: imagesRequestModel) { result in
            DispatchQueue.main.async { [weak self] in // TODO: Decorate Dispatch
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
                        image: UIImage(systemName: "xmark.seal.fill")?.pngData() ?? Data() // TODO: Refactor so ViewModel does not import UIKit
                    ))
                }
            }
        }
    }
}
