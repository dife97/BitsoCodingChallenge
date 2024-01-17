import UIKit
import ArtNetwork
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
        window?.rootViewController = getTemporaryViewController()
        window?.makeKeyAndVisible()
    }

    private func getTemporaryViewController() -> UIViewController {
        let urlSessionHTTPProvider = URLSessionHTTPProvider()
        let artService = ArtService(provider: urlSessionHTTPProvider)
        let remoteArtListUseCase = RemoteArtListUseCase(service: artService)
        let getImageUseCase = RemoteGetArtImagesUseCase(service: artService)
        let viewModel = ArtListViewModel(
            artListUseCase: remoteArtListUseCase,
            getImageUseCase: getImageUseCase
        )
        let viewController = ArtListViewController(viewModel: viewModel)
        viewModel.delegate = viewController
        return viewController
    }
}
