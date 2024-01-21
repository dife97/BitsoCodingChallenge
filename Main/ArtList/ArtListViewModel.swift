import Foundation
import ArtApp
import UIKit

protocol ArtListViewModelProtocol {
    func fetchArtList()
    func prefetchNextPage()
    func refreshArtsList()
}

protocol ArtListViewModelDelegate: AnyObject {
    func showErrorAlert(with alertErrorModel: AlertErrorModel)
    func showArtsList(with artItems: [ArtItemView])
    func showPrefetchedArtsList(with prefetchedArtItems: [ArtItemView])
    func showRefreshedArtsList(with refreshedArtItems: [ArtItemView])
    func updateArtImage(with artImage: ArtImageModel)
}

final class ArtListViewModel: ArtListViewModelProtocol {
    // MARK: - Dependency
    private let useCases: UseCases
    weak var delegate: ArtListViewModelDelegate?

    // MARK: Inner Type
    struct UseCases {
        let artsListManager: ArtsListProtocol
        let getArtImage: GetArtImagesProtocol
    }

    // MARK: - Initializer
    init(useCases: UseCases) {
        self.useCases = useCases
    }

    // MARK: - Public Methods
    func fetchArtList() {
        getArtsList { [weak self] result in
            guard let self else { return } // TODO: Add unit test tracking memory leak

            switch result {
            case .success(let artItems):
                delegate?.showArtsList(with: artItems)

            case .failure(let error):
                handleFetchArtsListError(error)
            }
        }
    }

    func prefetchNextPage() {
        getArtsList { [delegate] result in
            switch result {
            case .success(let artItems):
                delegate?.showPrefetchedArtsList(with: artItems)

            case .failure(let error):
                print("\(error)")
            }
        }
    }

    func refreshArtsList() {
        getArtsList(isRefreshing: true) { [delegate] result in
            switch result {
            case .success(let artItems):
                delegate?.showRefreshedArtsList(with: artItems)

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
        completion: @escaping (Result<[ArtItemView], ArtsListError>) -> Void
    ) {
        print("")
        useCases.artsListManager.getArtsList(isRefreshing: isRefreshing) { result in
            DispatchQueue.main.async { [weak self] in // TODO: Decorate Dispatch
                guard let self else { return }

                switch result {
                case .success(let artList):
                    var artItems: [ArtItemView] = []
                    artList.forEach {
                        artItems.append(ArtItemView(model: .init(
                            artId: $0.artId,
                            title: $0.title,
                            year: "\($0.year ?? 0)",
                            author: "\($0.author ?? "-")"
                        )))
                    }
                    completion(.success(artItems))
                    getImages(from: artList)

                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    private func handleFetchArtsListError(_ error: ArtsListError) {
        let alertErrorDescription: String = {
            switch error {
            case .isFetching:
                return ""
            case .connection:
                return "It seems that you have no internet connection"
            case .unexpected:
                return ""
            }
        }()

        let alertErrorModel: AlertErrorModel = .init(
            title: "Oops 😪",
            description: alertErrorDescription
        )
        delegate?.showErrorAlert(with: alertErrorModel)
    }

    private func getImages(from artList: ArtsList) {
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
