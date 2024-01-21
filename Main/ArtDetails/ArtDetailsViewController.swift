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
    private let viewModel: ArtDetailsInputProtocol
    private let infoModel: ArtDetailsInfoModel
    var artsDetailsView: ArtDetailsViewProtocol?

    // MARK: - Initializers
    init(
        viewModel: ArtDetailsInputProtocol,
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
        artsDetailsView?.setLoadingState(to: true)
        viewModel.getArtDetails(with: infoModel.artId)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
}

// MARK: - Private Methods
extension ArtDetailsViewController {
    private func configureNavigationBar() {
        let closeButton: UIBarButtonItem = .init(
            image: .init(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(closeButtonTapped)
        )
        closeButton.tintColor = .label
        navigationItem.rightBarButtonItem = closeButton
    }

    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Public Methods
extension ArtDetailsViewController: ArtDetailsOutputProtocol {
    func showArtDetails(with artDetailsModel: ArtDetailsSetupModel) {
        artsDetailsView?.setLoadingState(to: false)
        artsDetailsView?.showArtDetails(with: artDetailsModel)
    }
}
