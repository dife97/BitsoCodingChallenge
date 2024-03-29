import UIKit

final class ArtItemView: UIView {
    // MARK: - Inner Type
    struct ArtItemModel {
        let artId: Int
        let title: String
        let year: String
        let author: String
    }

    // MARK: - Properties
    private let artItemModel: ArtItemModel
    var artId: Int { artItemModel.artId }

    // MARK: - Initializers
    init(model: ArtItemModel) {
        artItemModel = model
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: Metrics
    struct ViewMetrics {
        static let cellHeight: CGFloat = 250
        static let artImageViewHeight: CGFloat = 150
    }

    // MARK: - UI
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            artImageView,
            artInfoLabel,
            authorLabel
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Metrics.Spacings.x2
        return stackView
    }()

    private lazy var artImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Metrics.Radius.x1
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemGray5
        return imageView
    }()

    private lazy var artInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = .mediumBold
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textColor = .label
        label.text = "\(artItemModel.title), \(artItemModel.year)"
        return label
    }()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .smallLight
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .label
        label.text = artItemModel.author
        return label
    }()

    // MARK: - Layout Setup
    private func setupView() {
        configureContentStackView()
        configureArtImageView()
    }

    private func configureContentStackView() {
        addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: Metrics.Spacings.x2
            ),
            contentStackView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: Metrics.Spacings.x2
            ),
            contentStackView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -Metrics.Spacings.x2
            )
        ])
    }

    private func configureArtImageView() {
        NSLayoutConstraint.activate([
            artImageView.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor),
            artImageView.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor),
            artImageView.heightAnchor.constraint(equalToConstant: ViewMetrics.artImageViewHeight)
        ])
    }

    // MARK: - Public Methods
    func updateArtImage(with image: UIImage) {
        artImageView.image = image
    }

    func getArtInfo() -> ArtDetailsInfoModel {
        .init(
            artId: artId,
            artImage: artImageView.image,
            title: artItemModel.title,
            author: artItemModel.author,
            year: artItemModel.year
        )
    }
}

// MARK: - Factory
extension ArtItemView: ArtItemViewFactory {
    func makeArtItemView() -> UIView { self }
    func getCellHeight() -> CGFloat { ViewMetrics.cellHeight }
}
