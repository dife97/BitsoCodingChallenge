import UIKit

final class ArtItemTableViewCell: UITableViewCell {
    static let identifier = String(describing: ArtItemTableViewCell.self)

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func configure(with view: UIView) {
        contentView.addSubview(view)
        setupConstraints(of: view)
    }

    func setupCell() {
        backgroundColor = .clear
        selectionStyle = .none
    }

    private func setupConstraints(of view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
