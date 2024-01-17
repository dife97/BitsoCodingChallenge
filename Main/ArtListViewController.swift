import UIKit

class ArtListViewController: UIViewController {
    // MARK: - Dependency
    private let viewModel: ArtListViewModelProtocol

    // MARK: - Initializers
    init(viewModel: ArtListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .orange

        viewModel.fetchArtList()
    }
}

