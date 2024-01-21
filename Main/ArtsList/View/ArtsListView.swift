import UIKit

protocol ArtListViewProtocol {
    func setLoadingState(to isLoading: Bool)
    func loadArtsList(with artsList: [ArtItemView])
    func loadRefreshedArtsList(with refreshedArtsList: [ArtItemView])
    func stopLoadingRefresh()
    func updateArtImage(with artImage: ArtImageModel)
}

protocol ArtsListViewDelegate: AnyObject {
    func prefetchNextPage()
    func refreshArtsList()
    func didTapArtItem(with artInfo: ArtDetailsInfoModel)
}

final class ArtsListView: UIView {
    // MARK: - Properties
    private var artsList: [ArtItemView] = []
    private weak var delegate: ArtsListViewDelegate?

    // MARK: - UI
    private lazy var artsListTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground
        tableView.indicatorStyle = .default
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = artsListRefreshControl
        tableView.separatorStyle = .none
        tableView.tableFooterView = artsListTableFooterView
        tableView.register(
            ArtItemTableViewCell.self,
            forCellReuseIdentifier: ArtItemTableViewCell.identifier
        )
        return tableView
    }()

    private lazy var artsListRefreshControl: UIRefreshControl = {
        let refreshControll = UIRefreshControl()
        refreshControll.tintColor = .label
        refreshControll.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        return refreshControll
    }()

    private lazy var artsListTableFooterView: UIView = {
        let view = UIView(frame: CGRect(
            x: 0, y: 0,
            width: UIScreen.main.bounds.size.width,
            height: 60) // TODO: Move to metrics
        )
        return view
    }()

    // MARK: - Initializers
    init(delegate: ArtsListViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Layout Setup
    private func setupView() {
        configureArtsListTableView()
        extraSetup()
    }

    private func configureArtsListTableView() {
        addSubview(artsListTableView)
        NSLayoutConstraint.activate([
            artsListTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            artsListTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            artsListTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            artsListTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func extraSetup() {
//        backgroundColor = .systemGray
        backgroundColor = .systemBackground
    }
}

// MARK: - Public Methods
extension ArtsListView: ArtListViewProtocol {
    func setLoadingState(to isLoading: Bool) {
        if isLoading {
            artsListTableView.isHidden = true
            startLoading()
        } else {
            artsListTableView.isHidden = false
            stopLoading()
        }
    }

    func loadArtsList(with artsList: [ArtItemView]) {
        self.artsList.append(contentsOf: artsList)
        artsListTableFooterView.stopLoading()
        artsListTableView.reloadData()
    }

    func loadRefreshedArtsList(with refreshedArtsList: [ArtItemView]) {
        stopLoadingRefresh()
        artsList = refreshedArtsList
        artsListTableView.reloadData()
    }

    func stopLoadingRefresh() {
        artsListTableView.refreshControl?.endRefreshing()
    }

    func updateArtImage(with artImage: ArtImageModel) {
        guard let artItemView = artsList.first(where: {
            $0.artId == artImage.artId
        }) else {
            return
        }

        guard let artImage = UIImage(data: artImage.image) else {
            return
        }

        artItemView.updateArtImage(with: artImage)
    }
}

// MARK: - Private Actions
extension ArtsListView {
    @objc private func didPullToRefresh(_ sender: UIRefreshControl) {
        delegate?.refreshArtsList()
    }
}

// MARK: - TableView DataSource
extension ArtsListView: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        artsList.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = ArtItemTableViewCell(
            style: .default,
            reuseIdentifier: ArtItemTableViewCell.identifier
        )
        let artItemView = artsList[indexPath.row].makeArtItemView()
        cell.configure(with: artItemView)
        return cell
    }
}

// MARK: - TableView Delegate
extension ArtsListView: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        artsList[indexPath.row].getCellHeight()
    }

    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        let itemPerPage = 10 // TODO: receive from model
        let firstPageItem = artsList.count - itemPerPage

        if indexPath.row == firstPageItem {
            artsListTableFooterView.startLoading()
            delegate?.prefetchNextPage()
        }
    }

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let artItemInfo = artsList[indexPath.row].getArtInfo()
        delegate?.didTapArtItem(with: artItemInfo)
    }
}
