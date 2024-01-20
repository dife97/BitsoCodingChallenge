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
        static let descriptionWidth: CGFloat = UIScreen.main.bounds.width * 0.65
    }

    // MARK: - UI
    private lazy var dividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray3
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14, weight: .bold) // TODO: Move to metrics
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .black
        label.text = "\(model.title)"
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .light) // TODO: Move to metrics
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .black
        label.text = "\(model.description)"
        return label
    }()

    // MARK: - Layout Setup
    private func setupView() {
        configureDividerView()
        configureLabels()
        extraSetup()
    }

    private func configureDividerView() {
        addSubview(dividerView)

        NSLayoutConstraint.activate([
            dividerView.topAnchor.constraint(equalTo: topAnchor),
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    private func configureLabels() {
        addSubview(descriptionLabel)
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            descriptionLabel.widthAnchor.constraint(equalToConstant: ViewMetrics.descriptionWidth),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),

            titleLabel.topAnchor.constraint(equalTo: descriptionLabel.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor, constant: -8)
        ])
    }

    private func extraSetup() {
        backgroundColor = .white
    }
}
