import UIKit

final class ArtDetailItemView: UIView {
    // MARK: - Properties
    private let model: ArtDetailItemModel

    // MARK: - Initializers
    init(model: ArtDetailItemModel) {
        self.model = model
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - View Metrics
    struct ViewMetrics {
        static let dividerHeight: CGFloat = 1
        static let descriptionWidth: CGFloat = UIScreen.main.bounds.width * 0.65
    }

    // MARK: - UI
    private lazy var dividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray4
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .smallBold
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .label
        label.text = "\(model.title)"
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .smallLight
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .label
        label.text = "\(model.description)"
        return label
    }()

    // MARK: - Layout Setup
    private func setupView() {
        configureDividerView()
        configureDescriptionLabel()
        configureTitleLabel()
        extraSetup()
    }

    private func configureDividerView() {
        addSubview(dividerView)

        NSLayoutConstraint.activate([
            dividerView.topAnchor.constraint(equalTo: topAnchor),
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: ViewMetrics.dividerHeight)
        ])
    }

    private func configureDescriptionLabel() {
        addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(
                equalTo: dividerView.bottomAnchor,
                constant: Metrics.Spacings.x2
            ),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            descriptionLabel.widthAnchor.constraint(equalToConstant: ViewMetrics.descriptionWidth),
            descriptionLabel.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -Metrics.Spacings.x2
            )
        ])
    }

    private func configureTitleLabel() {
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: descriptionLabel.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(
                equalTo: descriptionLabel.leadingAnchor,
                constant: -Metrics.Spacings.x1
            )
        ])
    }

    private func extraSetup() {
        backgroundColor = .systemBackground
    }
}
