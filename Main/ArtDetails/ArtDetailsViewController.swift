import UIKit

// TODO: Move to own file
struct ArtDetailsInfoModel {
    let artId: Int
    let artImage: UIImage?
    let title: String
    let author: String
    let year: String
}

final class ArtDetailsViewController: UIViewController {
    // MARK: - Dependencies
    private let viewModel: ArtDetailsViewModelProtocol
    private let infoModel: ArtDetailsInfoModel
    var artsDetailsView: ArtDetailsViewProtocol?

    // MARK: - Initializers
    init(
        viewModel: ArtDetailsViewModelProtocol,
        infoModel: ArtDetailsInfoModel
    ) {
        self.viewModel = viewModel
        self.infoModel = infoModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Life Cycles
    override func loadView() {
        view = ArtDetailsView(model: infoModel)
        artsDetailsView = view as? ArtDetailsViewProtocol
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        artsListView?.setLoadingState(to: true)
//        viewModel.fetchArtList()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
}

// MARK: - Private Methods
extension ArtDetailsViewController {
    private func configureNavigationBar() {
//        title = setupModel.title
//        navigationController?.navigationBar.prefersLargeTitles = true

        navigationItem.rightBarButtonItem = .init(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(closeButtonTapped)
        )
    }

    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
