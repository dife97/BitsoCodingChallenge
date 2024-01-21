import UIKit
import ArtNetwork
import ArtStore
import ArtApp

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UINavigationController(rootViewController: getTemporaryViewController())
        window?.makeKeyAndVisible()
    }

    private func getTemporaryViewController() -> UIViewController {
        let urlSessionHTTPProvider = URLSessionHTTPProvider()
        let artService = ArtService(provider: urlSessionHTTPProvider)
        let storeProvider = FileManagerStoreProvider()
        let artsListStore = ArtsListStore(provider: storeProvider)
        let artsListManager = ArtsListManager(
            remoteArtsList: artService,
            localArtsList: artsListStore
        )
        let getImageUseCase = RemoteGetArtImagesUseCase(service: artService)
        let viewModel = ArtListViewModel(useCases: .init(
            artsListManager: artsListManager,
            getArtImage: getImageUseCase
        ))
        let viewController = ArtListViewController(viewModel: viewModel)
        viewModel.viewController = viewController
        return viewController
    }
}
