import XCTest
@testable import ArtApp

final class RemoteArtDetailsUseCaseTests: XCTestCase {
    func test_executesWithCorrectArtId() {
        let (sut, serviceSpy) = buildSUT()
        let expectedRequestModel = makeDummyArtDetailsRequestModel()

        sut.execute(model: expectedRequestModel) { _ in }

        XCTAssertEqual(serviceSpy.receivedRequestModel, [expectedRequestModel])
    }

    func test_deliversConnectionError_whenClientCompletesWithConnectionError() {
        expect(.failure(.connection), serviceCompletesWith: .failure(.connection))
    }

    func test_deliversInvalidDataError_whenClientCompletesWithInvalidDataError() {
        expect(.failure(.invalidData), serviceCompletesWith: .failure(.invalidData))
    }

    func test_deliversUnexpectedError_whenClientCompletesWitUnexpectedError() {
        expect(.failure(.unexpected), serviceCompletesWith: .failure(.unexpected))
    }

    func test_deliversArtDetails_whenClientCompletesWithValidData() {
        let expectedArtDetails = makeDummyArtDetails()
        let artDetailsResponseModel = makeDummyArtDetailsResponseModel()
        expect(.success(expectedArtDetails), serviceCompletesWith: .success(artDetailsResponseModel))
    }

    func test_doesNotComplete_whenSUTIsDeallocatedBeforeClientCompletion() {
        let serviceSpy = RemoteArtDetailsServiceSpy()
        var sut: RemoteArtDetailsUseCase? = RemoteArtDetailsUseCase(service: serviceSpy)
        var result: ArtDetailsResult?

        sut?.execute(model: makeDummyArtDetailsRequestModel()) { result = $0 }
        sut = nil
        serviceSpy.complete(with: .failure(.connection))

        XCTAssertNil(result)
    }
}

// MARK: - Helpers
extension RemoteArtDetailsUseCaseTests {
    typealias SUT = (
        RemoteArtDetailsUseCase,
        RemoteArtDetailsServiceSpy
    )

    private func buildSUT() -> SUT {
        let serviceSpy = RemoteArtDetailsServiceSpy()
        let sut = RemoteArtDetailsUseCase(service: serviceSpy)
        return (sut, serviceSpy)
    }

    private func expect(
        _ expectedResult: ArtDetailsResult,
        serviceCompletesWith serviceResult: RemoteArtDetailsResult,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let (sut, serviceSpy) = buildSUT()
        let exp = expectation(description: "Wait to complete request")

        sut.execute(model: makeDummyArtDetailsRequestModel()) { receivedResult in
            switch (expectedResult, receivedResult) {
            case (.success(let expectedArtDetails), .success(let receivedArtDetails)):
                XCTAssertEqual(expectedArtDetails, receivedArtDetails, file: file, line: line)

            case (.failure(let expectedError), .failure(let receivedError)):
                XCTAssertEqual(expectedError, receivedError, file: file, line: line)
            default:
                XCTFail("Expected \(expectedResult) but received \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }

        serviceSpy.complete(with: serviceResult)
        wait(for: [exp], timeout: 1)
    }

    private func makeDummyArtDetails() -> ArtDetailsModel {
        .init(
            artId: "any id",
            title: "any title",
            date: "any data",
            artistInfo: "any info",
            description: "any description",
            place: "any place",
            medium: "any medium",
            dimensions: "any dimensions"
        )
    }
}
