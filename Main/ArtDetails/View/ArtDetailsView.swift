import UIKit

protocol ArtDetailsViewProtocol {
    func setLoadingState(to isLoading: Bool)
    func showArtDetails(with artDetailsModel: ArtDetailsSetupModel)
}

final class ArtDetailsView: UIView {
    // MARK: - Properties
    private let model: ArtDetailsInfoModel

    // MARK: - Initializers
    init(model: ArtDetailsInfoModel) {
        self.model = model
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - UI
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var artInfoStackView = makeStackView(
        arrangedSubview: [
            artImageView,
            artInfoLabel,
            authorLabel
        ],
        spacing: Metrics.Spacings.x4
    )

    private lazy var artImageView: UIImageView = {
        let imageView = UIImageView(image: model.artImage)
        imageView.heightAnchor.constraint(equalToConstant: ViewMetrics.artImageHeight).isActive = true
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Metrics.Radius.x1
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemGray5
        return imageView
    }()

    private lazy var artInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .titleBold
        label.textColor = .label
        label.text = "\(model.title) - \(model.year)"
        return label
    }()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .smallLight
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .label
        label.text = "\(model.author)"
        return label
    }()

    private lazy var loadingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var artDetailsStackView = makeStackView(spacing: .zero)

    // MARK: - View Metrics
    struct ViewMetrics {
        static let artImageHeight: CGFloat = UIScreen.main.bounds.height * 0.4
    }

    // MARK: - Layout Setup
    private func setupView() {
        configureScrollView()
        configureContainerView()
        configureArtInfoStackView()
        extraSetup()
    }

    private func configureScrollView() {
        addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func configureContainerView() {
        scrollView.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(
                equalTo: scrollView.bottomAnchor,
                constant: -Metrics.Spacings.x2
            ),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    private func configureArtInfoStackView() {
        containerView.addSubview(artInfoStackView)

        NSLayoutConstraint.activate([
            artInfoStackView.topAnchor.constraint(
                equalTo: containerView.topAnchor,
                constant: Metrics.Spacings.x2
            ),
            artInfoStackView.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: Metrics.Spacings.x2
            ),
            artInfoStackView.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: -Metrics.Spacings.x2
            )
        ])
    }

    private func configureLoadingView() {
        containerView.addSubview(loadingView)

        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: artInfoStackView.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            loadingView.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor,
                constant: -Metrics.Spacings.x3
            )
        ])
    }

    private func configureDescriptionLabel(with text: String) {
        if let data = text.data(using: .utf16),
           let attributedString = try? NSMutableAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
        ) {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .justified

            attributedString.addAttribute(
                .font,
                value: UIFont.smallLight,
                range: .init(
                    location: 0,
                    length: attributedString.length
                )
            )
            attributedString.addAttribute(
                .foregroundColor,
                value: UIColor.label,
                range: .init(
                    location: 0,
                    length: attributedString.length
                )
            )
            attributedString.addAttribute(
                .paragraphStyle,
                value: paragraphStyle,
                range: .init(
                    location: 0,
                    length: attributedString.length
                )
            )
            descriptionLabel.attributedText = attributedString
            artInfoStackView.addArrangedSubview(descriptionLabel)
        }
    }

    private func configureArtDetailsStackView() {
        containerView.addSubview(artDetailsStackView)

        NSLayoutConstraint.activate([
            artDetailsStackView.topAnchor.constraint(
                equalTo: artInfoStackView.bottomAnchor,
                constant: Metrics.Spacings.x5
            ),
            artDetailsStackView.leadingAnchor.constraint(equalTo: artInfoStackView.leadingAnchor),
            artDetailsStackView.trailingAnchor.constraint(equalTo: artInfoStackView.trailingAnchor),
            artDetailsStackView.bottomAnchor.constraint(
                equalTo: containerView.bottomAnchor,
                constant: -Metrics.Spacings.x2
            )
        ])
    }

    private func extraSetup() {
        backgroundColor = .systemBackground
        artInfoStackView.setCustomSpacing(Metrics.Spacings.x1, after: artInfoLabel)
    }
}

// MARK: - Public Methods
extension ArtDetailsView: ArtDetailsViewProtocol {
    func setLoadingState(to isLoading: Bool) {
        if isLoading {
            configureLoadingView()
            loadingView.startLoading()
        } else {
            loadingView.stopLoading()
            loadingView.removeFromSuperview()
        }
    }

    func showArtDetails(with artDetailsModel: ArtDetailsSetupModel) {
        if let descriptionText = artDetailsModel.description {
            configureDescriptionLabel(with: descriptionText)
        }

        configureArtDetailsStackView()

        artDetailsModel.details.forEach {
            let artDetailItemView = ArtDetailItemView(model: $0)
            artDetailsStackView.addArrangedSubview(artDetailItemView)
        }
    }
}

// MARK: - Factories
extension ArtDetailsView {
    private func makeStackView(
        arrangedSubview: [UIView] = [],
        spacing: CGFloat
    ) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubview)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = spacing
        return stackView
    }
}
