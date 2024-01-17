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
    
    let imageView = UIImageView()
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemPink

        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.heightAnchor.constraint(equalToConstant: 150),
        ])

        viewModel.fetchArtList()
    }
}

extension ArtListViewController: ArtListViewModelDelegate {
    func updateImage(with imageData: Data) {
        guard let image = UIImage(data: imageData) else {
            return
        }

        DispatchQueue.main.sync {
            imageView.image = image
        }
    }
}
