import XCTest
import ArtApp
@testable import Main

final class ArtsListViewModelTests: XCTestCase {
    func test_fetchArtList_callsManagerAsNotRefreshing() {
//        let artsListManager = ArtsListManagerSpy()
//        let (sut, _) = buildSUT(artsListManager: artsListManager)
//
//        sut.fetchArtList()
//
//        XCTAssertEqual(artsListManager.receivedIsFreshingValues, [false])
    }

    func test_fetchArtList_showsConnectionAlertError_whenManagerCompletesWithConnectionError() {
//        let artsListManager = ArtsListManagerSpy()
//        let (sut, viewControllerSpy) = buildSUT(artsListManager: artsListManager)
//        let expectedAlertErrorModel: AlertErrorModel = .init(
//            title: "Oops 😪",
//            description: "It seems that you have no internet connection"
//        )
//
//        sut.fetchArtList()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            XCTAssertEqual(viewControllerSpy.receivedAlertErrorModel, [expectedAlertErrorModel])
//        }
//        artsListManager.complete(with: .failure(.connection))

        let artsListManager = ArtsListManagerDummy()
        let (sut, viewControllerSpy) = buildSUT(artsListManager: artsListManager)
        let expectedAlertErrorModel: AlertErrorModel = .init(
            title: "Oops 😪",
            description: "It seems that you have no internet connection"
        )
        artsListManager.artsListResultToReturn = .failure(.connection)
        sut.fetchArtList()

        XCTAssertEqual(viewControllerSpy.receivedAlertErrorModel, [expectedAlertErrorModel])
    }

    func test_fetchArtList_showsUnexpectedAlertError_whenManagerCompletesWithUnexpectedError() {

    }

    func test_fetchArtList_showsArtsList_whenManagerCompletesWithArtsList() {

    }
}

// MARK: - Helpers
extension ArtsListViewModelTests {
    typealias SUT = (
        ArtListViewModel,
        ArtsListViewControllerSpy
    )

    private func buildSUT(
        artsListManager: ArtsListProtocol = ArtsListManagerSpy(),
        getArtImage: RemoteGetArtImagesSpy = RemoteGetArtImagesSpy()
    ) -> SUT {
        let viewControllerSpy = ArtsListViewControllerSpy()
        let sut = ArtListViewModel(useCases: .init(
            artsListManager: artsListManager,
            getArtImage: getArtImage
        ))
        sut.delegate = viewControllerSpy
        return (sut, viewControllerSpy)
    }
}
