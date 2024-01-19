import UIKit

protocol ArtDetailsViewProtocol {

}

final class ArtDetailsView: UIView {
    // MARK: - Properties
    private let model: ArtDetailsInfoModel

    // MARK: - UI
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            artImageView,
            titleLabel,
            artInfoLabel
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 24
        return stackView
    }()

    private lazy var artImageView: UIImageView = {
        let imageView = UIImageView(image: model.artImage)
        imageView.heightAnchor.constraint(equalToConstant: ViewMetrics.artImageHeight).isActive = true
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Metrics.Radius.defaultValue
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 18, weight: .bold) // TODO: Move to metrics
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .black
        label.text = "\(model.title)"
        return label
    }()

    private lazy var artInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14, weight: .light) // TODO: Move to metrics
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .black
        label.text = "\(model.author) - \(model.year)"
        return label
    }()

    // MARK: - View Metrics
    struct ViewMetrics {
        static let artImageHeight: CGFloat = 400
    }

    // MARK: - Initializers
    init(model: ArtDetailsInfoModel) {
        self.model = model
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Layout Setup
    private func setupView() {
        configureContentStackView()
        extraSetup()
    }

    private func configureContentStackView() {
        addSubview(contentStackView)

        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Metrics.Spacings.defaultValue),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.Spacings.defaultValue),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metrics.Spacings.defaultValue)
        ])
    }

    private func extraSetup() {
        backgroundColor = .white
        contentStackView.setCustomSpacing(8, after: titleLabel)
    }
}

extension ArtDetailsView: ArtDetailsViewProtocol {

}
