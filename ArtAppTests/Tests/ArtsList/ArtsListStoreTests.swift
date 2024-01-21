import XCTest
import ArtStore
@testable import ArtApp

final class ArtStoreTests: XCTestCase {
    // MARK: - Save Arts List
    func test_saveArtsList_deliversInvalidRequestError_whenArtsListRequestModelIsEmpty() {
        let (sut, _) = buildSUT()
        let exp = expectation(description: "Wait store to complete")

        sut.saveArtsList(model: []) { error in
            switch error {
            case .invalidRequest:
                break
            default:
                XCTFail("Expected invalidRequest error and received \(String(describing: error)) instead")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }

    func test_saveArtsList_sendsCorrectPath() {
        let (sut, providerSpy) = buildSUT()
        let artsList: ArtsList = makeDummyArtsList()
        let expectedPath = "arts-list"

        sut.saveArtsList(model: artsList) { _ in }

        XCTAssertEqual(providerSpy.receivedInsertPath, [expectedPath])
    }

    func test_saveArtsList_deliversUnexpectedError_whenStoreCompletesWithUnexpected() {
        expectSaveArtsList(.unexpected, whenStoreCompletesWith: .unexpected)
    }

    func test_saveArtsList_deliversInvalidRequestError_whenStoreCompletesWithInvalidRequest() {
        expectSaveArtsList(.invalidRequest, whenStoreCompletesWith: .invalidRequest)
    }

    func test_saveArtsList_deliversNoError_whenStoreCompletesSuccesfully() {
        expectSaveArtsList(nil, whenStoreCompletesWith: nil)
    }

    // MARK: - Get Arts List
    func test_getArtsList_sendsCorrectPath() {
        let (sut, providerSpy) = buildSUT()
        let expectedPath = "arts-list"

        sut.getArtsList { _ in }

        XCTAssertEqual(providerSpy.receivedRetrievePath, [expectedPath])
    }

    func test_getArtsList_deliversNil_whenStoreCompletesWithEmpty() {
        expectGetArtsList(.success(nil), whenStoreCompletesWith: .empty)
    }

    func test_getArtsList_deliversInvalidRequestError_whenStoreCompletesWithInvalidRequest() {
        expectGetArtsList(.failure(.invalidRequest), whenStoreCompletesWith: .error(.invalidRequest))
    }

    func test_getArtsList_deliversUnexpectedError_whenStoreCompletesWithUnexpected() {
        expectGetArtsList(.failure(.unexpected), whenStoreCompletesWith: .error(.unexpected))
    }

    func test_getArtsList_deliversUnexpectedError_whenStoreCompletesWithInvalidData() {
        let invalidCache: CacheDataModel = .init(data: makeInvalidData())
        expectGetArtsList(.failure(.unexpected), whenStoreCompletesWith: .retrievedData(invalidCache))
    }

    func test_getArtsList_deliversArtsList_whenStoreCompletesWithValidData() {
        let expectedArtsList = makeDummyArtsList()
        guard let expectedArtsListData = expectedArtsList.toData() else { return }
        let validCache: CacheDataModel = .init(data: expectedArtsListData)
        expectGetArtsList(.success(expectedArtsList), whenStoreCompletesWith: .retrievedData(validCache))
    }

    // MARK: - Delete Arts List
    func test_cleanArtsList_sendsCorrectPath() {
        let (sut, providerSpy) = buildSUT()
        let expectedPath = "arts-list"

        sut.cleanArtsList { _ in }

        XCTAssertEqual(providerSpy.receivedDeletePath, [expectedPath])
    }

    func test_cleanArtsList_deliversUnexpectedError_whenDeletionCompletesWithUnexpected() {
        expectCleanArtsList(.unexpected, whenStoreCompletesWith: .unexpected)
    }

    func test_cleanArtsList_deliversInvalidRequestError_whenDeletionCompletesWithInvalidRequest() {
        expectCleanArtsList(.invalidRequest, whenStoreCompletesWith: .invalidRequest)
    }

    func test_cleanArtsList_deliversNoError_whenDeletionCompletesSuccesfully() {
        expectCleanArtsList(nil, whenStoreCompletesWith: nil)
    }
}

// MARK: - Helpers
extension ArtStoreTests {
    typealias SUT = (
        ArtsListStore,
        StoreProviderSpy
    )

    private func buildSUT() -> SUT {
        let storeProviderSpy = StoreProviderSpy()
        let sut = ArtsListStore(provider: storeProviderSpy)
        return (sut, storeProviderSpy)
    }

    private func expectSaveArtsList(
        _ expectedResult: ArtsListStoreError?,
        whenStoreCompletesWith storeResult: StoreProviderError?,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let (sut, providerSpy) = buildSUT()
        let artsList: ArtsList = makeDummyArtsList()
        let exp = expectation(description: "Wait store to complete")
        sut.saveArtsList(model: artsList) { receivedResult in
            XCTAssertEqual(
                expectedResult,
                receivedResult,
                "Expected \(String(describing: expectedResult)) error and received \(String(describing: receivedResult)) instead",
                file: file,
                line: line
            )
            exp.fulfill()
        }
        providerSpy.completeInsert(with: storeResult)
        wait(for: [exp], timeout: 1)
    }

    private func expectGetArtsList(
        _ expectedResult: LocalArtsListResult,
        whenStoreCompletesWith storeResult: RetriveResult,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let (sut, providerSpy) = buildSUT()
        let exp = expectation(description: "Wait store to complete")
        sut.getArtsList { receivedResult in
            switch (expectedResult, receivedResult) {
            case (.success(let expectedArtsList), .success(let receivedArtsList)):
                XCTAssertEqual(expectedArtsList, receivedArtsList, file: file, line: line)
            case (.failure(let expectedError), .failure(let receivedError)):
                XCTAssertEqual(expectedError, receivedError, file: file, line: line)
            default:
                XCTFail("Expected \(expectedResult) but received \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        providerSpy.completeRetrieve(with: storeResult)
        wait(for: [exp], timeout: 1)
    }

    private func expectCleanArtsList(
        _ expectedResult: ArtsListStoreError?,
        whenStoreCompletesWith storeResult: StoreProviderError?,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let (sut, providerSpy) = buildSUT()
        let exp = expectation(description: "Wait store to complete")
        sut.cleanArtsList { receivedResult in
            XCTAssertEqual(
                expectedResult,
                receivedResult,
                "Expected \(String(describing: expectedResult)) error and received \(String(describing: receivedResult)) instead",
                file: file,
                line: line
            )
            exp.fulfill()
        }
        providerSpy.completeDelete(with: storeResult)
        wait(for: [exp], timeout: 1)
    }

    private func makeDummyArtsList() -> ArtsList {
        [
            .init(artId: 1, imageId: "any id", title: "any title", year: nil, author: nil),
            .init(artId: 2, imageId: "any id", title: "any title", year: 23, author: nil),
        ]
    }
}
