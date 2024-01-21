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

    // segregate into Configure methods (hierarquia) pra todos
    func configure(with view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(view)

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func setupCell() {
        backgroundColor = .clear
        selectionStyle = .none
    }
}
