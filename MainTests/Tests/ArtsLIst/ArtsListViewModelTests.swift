import XCTest
import ArtApp
@testable import Main

final class ArtsListViewModelTests: XCTestCase {
    func test_fetchArtList_callsManagerAsNotRefreshing() {
        let artsListManager = ArtsListManagerSpy()
        let (sut, _) = buildSUT(artsListManager: artsListManager)

        sut.fetchArtList()

        XCTAssertEqual(artsListManager.receivedIsFreshingValues, [false])
    }

    // TODO: More tests to be added
}

// MARK: - Helpers
extension ArtsListViewModelTests {
    typealias SUT = (
        ArtsListViewModel,
        ArtsListViewControllerSpy
    )

    private func buildSUT(
        artsListManager: ArtsListProtocol = ArtsListManagerSpy(),
        getArtImage: RemoteGetArtImagesSpy = RemoteGetArtImagesSpy()
    ) -> SUT {
        let viewControllerSpy = ArtsListViewControllerSpy()
        let sut = ArtsListViewModel(useCases: .init(
            artsListManager: artsListManager,
            getArtImage: getArtImage
        ))
        sut.viewController = viewControllerSpy
        return (sut, viewControllerSpy)
    }
}
