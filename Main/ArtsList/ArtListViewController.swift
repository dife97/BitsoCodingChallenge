import UIKit
import ArtApp
import ArtNetwork

final class ArtListViewController: UIViewController {
    // MARK: - Dependencies
    private let viewModel: ArtsListInputProtocol
    var artsListView: ArtListViewProtocol?

    // MARK: - Initializers
    init(viewModel: ArtsListInputProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Life Cycles
    override func loadView() {
        view = ArtsListView(delegate: self)
        artsListView = view as? ArtListViewProtocol
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        artsListView?.setLoadingState(to: true)
        viewModel.fetchArtList()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
}

// MARK: - Private Methods
extension ArtListViewController {
    private func configureNavigationBar() {
        title = "Arts List"
    }
}

// MARK: - Display Logic
extension ArtListViewController: ArtsListOutputProtocol {
    func showFetchArtsListError(with alertErrorModel: AlertErrorModel) {
        artsListView?.setLoadingState(to: false)

        showAlert(
            title: alertErrorModel.title,
            message: alertErrorModel.description,
            buttonTitle: alertErrorModel.confirmButtonTitle
        )
    }

    func showArtsList(with artItems: [ArtItemView]) {
        artsListView?.setLoadingState(to: false)
        artsListView?.loadArtsList(with: artItems)
    }

    func showPrefetchedArtsList(with prefetchedArtItems: [ArtItemView]) {
        artsListView?.loadArtsList(with: prefetchedArtItems)
    }

    func showRefreshedArtsList(with refreshedArtItems: [ArtItemView]) {
        artsListView?.loadRefreshedArtsList(with: refreshedArtItems)
    }

    func showRefreshedArtsListError(with alertErrorModel: AlertErrorModel) {
        artsListView?.stopLoadingRefresh()

        showAlert(
            title: alertErrorModel.title,
            message: alertErrorModel.description,
            buttonTitle: alertErrorModel.confirmButtonTitle
        )
    }

    func updateArtImage(with artImage: ArtImageModel) {
        artsListView?.updateArtImage(with: artImage)
    }
}

// MARK: - View Delegate
extension ArtListViewController: ArtsListViewDelegate {
    func prefetchNextPage() {
        viewModel.prefetchNextPage()
    }

    func refreshArtsList() {
        viewModel.refreshArtsList()
    }

    func didTapArtItem(with artInfo: ArtDetailsInfoModel) {
        // TODO: Move to configurator and remove import ArtApp
        let provider = URLSessionHTTPProvider()
        let service = ArtService(provider: provider)
        let getArtDetailsUseCase = RemoteArtDetailsUseCase(service: service)
        let viewModel = ArtDetailsViewModel(getArtDetailsUseCase: getArtDetailsUseCase)
        let viewController = ArtDetailsViewController(
            viewModel: viewModel,
            infoModel: artInfo
        )
        viewModel.viewController = viewController
        let artDetailNavigationController = UINavigationController(rootViewController: viewController)
        navigationController?.showDetailViewController(artDetailNavigationController, sender: self)
    }
}
