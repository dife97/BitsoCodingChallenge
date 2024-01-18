import UIKit

final class ArtListViewController: UIViewController {
    // MARK: - Dependencies
    private let viewModel: ArtListViewModelProtocol
    var artsListView: ArtListViewProtocol?

    // MARK: - Initializers
    init(viewModel: ArtListViewModelProtocol) {
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
        viewModel.fetchArtList(isPrefetch: false)
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
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

// MARK: - Display Logic
extension ArtListViewController: ArtListViewModelDelegate {
    func displayArtsList(with artItems: [ArtItemView]) {
        artsListView?.setLoadingState(to: false) // TODO: Add tests
        artsListView?.loadArtsList(with: artItems)
    }

    func displayPrefetchedArtsList(with prefetchedArtItems: [ArtItemView]) {
        artsListView?.loadArtsList(with: prefetchedArtItems)
    }

    func updateArtImage(with artImage: ArtImageModel) {
        artsListView?.updateArtImage(with: artImage)
    }
}

// MARK: - View Delegate
extension ArtListViewController: ArtsListViewDelegate {
    func prefetch() {
        viewModel.fetchArtList(isPrefetch: true)
    }
}
