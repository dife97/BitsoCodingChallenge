import XCTest
import ArtNetwork
@testable import ArtApp

extension ArtServiceTests {
    func test_getArtDetails_sendsCorrectTarget() {
        let (sut, providerSpy) = buildSUT()
        let requestModel: ArtDetailsRequestModel = makeDummyArtDetailsRequestModel()
        let getArtDetailsTarget: ArtServiceTarget = .getArtDetails(requestModel)

        sut.getArtDetails(requestModel: requestModel) { _  in }

        assertArtServiceTarget(getArtDetailsTarget, from: providerSpy)
    }

    func test_getArtDetails_deliversUnexpectedError_whenProviderCompletesWithInvalidRequest() {
        expectGetArtDetails(.failure(.unexpected), whenProviderCompletesWith: .failure(.invalidRequest))
    }

    func test_getArtDetails_deliversUnexpectedError_whenProviderCompletesWithInvalidData() {
        expectGetArtDetails(.failure(.unexpected), whenProviderCompletesWith: .failure(.invalidData))
    }

    func test_getArtDetails_deliversUnexpectedError_whenProviderCompletesWithUnexpected() {
        expectGetArtDetails(.failure(.unexpected), whenProviderCompletesWith: .failure(.unexpected))
    }

    func test_getArtDetails_deliversInvalidDataError_whenProviderCompletesWithInvalidData() {
        expectGetArtDetails(.failure(.invalidData), whenProviderCompletesWith: .success(makeInvalidData()))
    }

    func test_getArtDetails_deliversArtDetails_whenProviderCompletesWithValidData() {
        let expectedArtDetails = makeDummyArtDetailsResponseModel()
        expectGetArtDetails(
            .success(expectedArtDetails),
            whenProviderCompletesWith: .success(expectedArtDetails.toData())
        )
    }
}

// MARK: - Helpers
extension ArtServiceTests {
    private func expectGetArtDetails(
        _ expectedResult: RemoteArtDetailsResult,
        whenProviderCompletesWith providerResult: HTTPProviderResult,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let (sut, providerSpy) = buildSUT()
        let requestModel: ArtDetailsRequestModel = makeDummyArtDetailsRequestModel()
        let exp = expectation(description: "Wait for provider request")

        sut.getArtDetails(requestModel: requestModel) { receivedResult in
            switch (expectedResult, receivedResult) {
            case (.success(let expectedArtDetailsResponse), .success(let receivedArtDetailsResponse)):
                XCTAssertEqual(expectedArtDetailsResponse, receivedArtDetailsResponse, file: file, line: line)

            case (.failure(let expectedError), .failure(let receivedError)):
                XCTAssertEqual(expectedError, receivedError, file: file, line: line)
            default:
                XCTFail("Expected \(expectedResult) but received \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }

        providerSpy.complete(with: providerResult)
        wait(for: [exp], timeout: 1)
    }
}
