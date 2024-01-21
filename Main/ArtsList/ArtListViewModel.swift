import Foundation
import ArtApp
import UIKit

protocol ArtsListInputProtocol {
    func fetchArtList()
    func prefetchNextPage()
    func refreshArtsList()
}

protocol ArtsListOutputProtocol: AnyObject {
    func showArtsList(with artItems: [ArtItemView])
    func showFetchArtsListError(with alertErrorModel: AlertErrorModel)
    func showPrefetchedArtsList(with prefetchedArtItems: [ArtItemView])
    func showRefreshedArtsList(with refreshedArtItems: [ArtItemView])
    func showRefreshedArtsListError(with alertErrorModel: AlertErrorModel)
    func updateArtImage(with artImage: ArtImageModel)
}

final class ArtListViewModel: ArtsListInputProtocol {
    // MARK: - Dependency
    private let useCases: UseCases
    weak var viewController: ArtsListOutputProtocol?

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
            guard let self else { return }

            switch result {
            case .success(let artItems):
                viewController?.showArtsList(with: artItems)

            case .failure(let error):
                handleFetchArtsListError(error)
            }
        }
    }

    func prefetchNextPage() {
        getArtsList { [viewController] result in
            switch result {
            case .success(let artItems):
                viewController?.showPrefetchedArtsList(with: artItems)

            case .failure(let error):
                print("\(error)") // TODO: Remove print
            }
        }
    }

    func refreshArtsList() {
        getArtsList(isRefreshing: true) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let artItems):
                viewController?.showRefreshedArtsList(with: artItems)

            case .failure(let error):
                handleRefreshArtsListError(error)
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
        switch error {
        case .isFetching:
            break
        case .connection:
            showAlertError(with: .init(
                title: "Oops 😪",
                description: "It seems that you have no internet connection.",
                confirmButtonTitle: "Ok"
            ))
        case .unexpected:
            showAlertError(with: .init(
                title: "Oops 😪",
                description: "Something wrong happened.",
                confirmButtonTitle: "Try Again"
            ))
        }
    }

    private func handleRefreshArtsListError(_ error: ArtsListError) {
        viewController?.showRefreshedArtsListError(with: .init(
            title: "Oops 😪",
            description: "Something wrong happened.",
            confirmButtonTitle: "Ok"
        ))
    }

    private func showAlertError(with alertErrorModel: AlertErrorModel) {
        let alertErrorModel: AlertErrorModel = .init(
            title: alertErrorModel.title,
            description: alertErrorModel.description,
            confirmButtonTitle: alertErrorModel.confirmButtonTitle
        )
        viewController?.showFetchArtsListError(with: alertErrorModel)
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
                    viewController?.updateArtImage(with: .init(
                        artId: data.artId,
                        image: data.imageData
                    ))

                case .failure(let error):
                    viewController?.updateArtImage(with: .init(
                        artId: error.artId,
                        image: UIImage(systemName: "xmark.seal.fill")?.pngData() ?? Data() // TODO: Refactor so ViewModel does not import UIKit
                    ))
                }
            }
        }
    }
}
