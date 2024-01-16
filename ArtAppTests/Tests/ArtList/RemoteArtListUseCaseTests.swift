import XCTest
import ArtApp

final class RemoteArtListUseCaseTests: XCTestCase {
    // executes first request with correct model
    func test_execute_sendCorrectModel_whenFirstRequest() {
        let (sut, httpClient) = buildSUT()
        let expectedFirstRequestModel: ArtListRequestModel = .init(
            page: 1,
            limit: 10
        )

        sut.execute { _ in }

        XCTAssertEqual(httpClient.receivedRequestModel, [expectedFirstRequestModel])
    }


    // executes with correct data

    // completes with error when client completes with error
    // completes with connection error when client complete with connection error

    // completes with art List when client completes with valid data art list
    // completes with data error when client completes with invalid data

    // does not complete if sut is deallocated
}

// MARK: - Helpers
extension RemoteArtListUseCaseTests {
    typealias SUT = (
        RemoteArtListUseCase,
        RemoteArtListServiceSpy
    )

    private func buildSUT() -> SUT {
        let serviceSpy = RemoteArtListServiceSpy()
        let sut = RemoteArtListUseCase(service: serviceSpy)
        return (sut, serviceSpy)
    }
}
