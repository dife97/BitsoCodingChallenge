import UIKit

final class ArtsListViewController: UIViewController {
    // MARK: - Dependencies
    typealias ViewModel = ArtsListInputProtocol & ArtsListCoordinatorProtocol
    private let viewModel: ViewModel
    var artsListView: ArtListViewProtocol?

    // MARK: - Initializers
    init(viewModel: ViewModel) {
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
extension ArtsListViewController {
    private func configureNavigationBar() {
        title = "Arts List"
    }
}

// MARK: - Display Logic
extension ArtsListViewController: ArtsListOutputProtocol {
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

    func showPrefetchError() {
        artsListView?.setFooterViewLoadingState(to: false)
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
extension ArtsListViewController: ArtsListViewDelegate {
    func prefetchNextPage() {
        viewModel.prefetchNextPage()
    }

    func refreshArtsList() {
        viewModel.refreshArtsList()
    }

    func didTapArtItem(with artDetailsInfo: ArtDetailsInfoModel) {
        viewModel.showArtDetails?(artDetailsInfo)
    }
}
