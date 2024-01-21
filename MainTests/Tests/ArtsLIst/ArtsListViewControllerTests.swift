import XCTest
@testable import Main

final class ArtsListViewControllerTests: XCTestCase {
    func test_loadView_instatiateArtListViewAndStoreIt() {
        let viewModelSpy = ArtListViewModelSpy()
        let sut = ArtListViewController(viewModel: viewModelSpy)

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
}

// MARK: - Helpers
extension ArtsListViewControllerTests {
    private func buildSUT(
        viewModel: ArtListViewModelSpy = ArtListViewModelSpy(),
        artListView: ArtListViewSpy = ArtListViewSpy()
    ) -> ArtListViewController {
        let sut = ArtListViewController(viewModel: viewModel)
        sut.artsListView = artListView
        return sut
    }
}
