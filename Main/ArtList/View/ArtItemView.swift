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

    // MARK: - UI
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            artImageView,
            artInfoLabel,
            authorLabel
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()

    private lazy var artImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Metrics.Radius.defaultValue
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray
        return imageView
    }()

    private lazy var artInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .bold) // TODO: Move to metrics
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .black
        label.text = "\(artItemModel.title), \(artItemModel.year)"
        return label
    }()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .medium) // TODO: Move to metrics
        label.textColor = .black
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
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
        ])
    }

    private func configureArtImageView() {
        NSLayoutConstraint.activate([
            artImageView.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor),
            artImageView.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor),
            artImageView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }

    func updateArtImage(with image: UIImage) {
        artImageView.image = image
    }
}

extension ArtItemView: ArtItemViewFactory {
    func makeArtItemView() -> UIView { self }
    func getCellHeight() -> CGFloat { 235 }
}