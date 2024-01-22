import XCTest
@testable import Main

final class ArtsListViewControllerTests: XCTestCase {
    func test_loadView_instatiateArtListViewAndStoreIt() {
        let viewModelSpy = ArtListViewModelSpy()
        let sut = ArtsListViewController(viewModel: viewModelSpy)

        sut.loadView()

        XCTAssertTrue(sut.view is ArtListViewProtocol)
        XCTAssertNotNil(sut.artsListView)
    }

    func test_viewDidLoad_callsViewToStartLoading() {
        let artListView = ArtListViewSpy()
        let sut = buildSUT(artListView: artListView)

        sut.viewDidLoad()

        XCTAssertEqual(artListView.receivedLoadingStates, [true])
    }

    func test_viewDidLoad_callsViewModelToFetchArtsList() {
        let viewModelSpy = ArtListViewModelSpy()
        let sut = buildSUT(viewModel: viewModelSpy)

        sut.viewDidLoad()

        XCTAssertEqual(viewModelSpy.fetchArtListCalled, [true])
    }

    // TODO: More tests to be added
}

// MARK: - Helpers
extension ArtsListViewControllerTests {
    private func buildSUT(
        viewModel: ArtListViewModelSpy = ArtListViewModelSpy(),
        artListView: ArtListViewSpy = ArtListViewSpy()
    ) -> ArtsListViewController {
        let sut = ArtsListViewController(viewModel: viewModel)
        sut.artsListView = artListView
        return sut
    }
}
