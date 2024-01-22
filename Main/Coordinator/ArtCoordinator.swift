import UIKit
import ArtNetwork
import ArtStore
import ArtApp

public protocol CoordinatorProtocol: AnyObject {
    func start()
}

final class ArtCoordinator: CoordinatorProtocol {
    // MARK: - Dependencies
    private let navigationController: UINavigationController
    private let urlSessionHTTPProvider = URLSessionHTTPProvider()
    private let fileManagerStoreProvider = FileManagerStoreProvider()

    // MARK: - Initializer
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Start
    func start() {
        let artsListViewController = makeArtsListViewController()
        navigationController.pushViewController(artsListViewController, animated: false)
    }
}

// MARK: - Private Methods
extension ArtCoordinator {
    private func showArtDetails(with artDetailsInfo: ArtDetailsInfoModel) {
        let viewController = makeArtDetailsViewController(with: artDetailsInfo)
        navigationController.showDetailViewController(viewController, sender: self)
    }
}

// MARK: - Factories
extension ArtCoordinator {
    private func makeArtsListViewController() -> UIViewController {
        let artService = ArtService(provider: urlSessionHTTPProvider)
        let artsListManager = ArtsListManager(
            remoteArtsList: artService,
            localArtsList: ArtsListStore(provider: fileManagerStoreProvider)
        )
        let remoteGetImagesUseCase = RemoteGetArtImagesUseCase(service: artService)
        let viewModel = ArtsListViewModel(useCases: .init(
            artsListManager: artsListManager,
            getArtImage: remoteGetImagesUseCase
        ))
        let viewController = ArtsListViewController(viewModel: viewModel)
        viewModel.viewController = viewController
        viewModel.showArtDetails = showArtDetails
        return viewController
    }

    private func makeArtDetailsViewController(with infoModel: ArtDetailsInfoModel) -> UIViewController {
        let artService = ArtService(provider: urlSessionHTTPProvider)
        let remoteArtDetails = RemoteArtDetailsUseCase(service: artService)
        let viewModel = ArtDetailsViewModel(getArtDetailsUseCase: remoteArtDetails)
        let viewController = ArtDetailsViewController(
            viewModel: viewModel,
            infoModel: infoModel
        )
        viewModel.viewController = viewController
        return UINavigationController(rootViewController: viewController)
    }
}
