import XCTest
@testable import ArtApp

final class ArtsListManagerTests: XCTestCase {
    // MARK: - Remote UseCase
    func test_callsRemoteArtsListAndDoesNotCallLocal_whenFirstRequest() {
        let (sut, remoteArtsList, localArtsList) = buildSUT()
        sut.getArtsList(isRefreshing: false) { _ in }

        XCTAssertTrue(localArtsList.getArtsListCalled.isEmpty)
        XCTAssertTrue(remoteArtsList.receivedModel.count == 1)
    }

    func test_callsRemoteArtsListWithCorrectRequestData_whenNotRefreshing() {
        let (sut, remoteArtsList, localArtsList) = buildSUT()
        let expectedLimit = 10
        let expectedRequestModel: [ArtsListRequestModel] = [
            .init(page: 1, limit: expectedLimit),
            .init(page: 2, limit: expectedLimit),
            .init(page: 3, limit: expectedLimit),
            .init(page: 4, limit: expectedLimit),
        ]

        expectedRequestModel.forEach { _ in
            sut.getArtsList(isRefreshing: false) { _ in }
            remoteArtsList.complete(with: .success(makeDummyArtsListResponseModel()))
        }

        XCTAssertTrue(localArtsList.getArtsListCalled.isEmpty)
        XCTAssertEqual(remoteArtsList.receivedModel, expectedRequestModel)
    }

    func test_callsRemoteArtsListWithCorrectRequestData_whenRefreshing() {
        let (sut, remoteArtsList, _) = buildSUT()
        let expectedRequestModel: ArtsListRequestModel = .init(page: 1, limit: 10)

        sut.getArtsList(isRefreshing: true) { _ in }
        remoteArtsList.complete(with: .success(makeDummyArtsListResponseModel()))

        sut.getArtsList(isRefreshing: true) { _ in }
        remoteArtsList.complete(with: .failure(.connection))

        sut.getArtsList(isRefreshing: true) { _ in }
        remoteArtsList.complete(with: .failure(.invalidData))

        sut.getArtsList(isRefreshing: true) { _ in }
        remoteArtsList.complete(with: .failure(.unexpected))

        XCTAssertEqual(remoteArtsList.receivedModel, [
            expectedRequestModel,
            expectedRequestModel,
            expectedRequestModel,
            expectedRequestModel
        ])
    }

    func test_deliversIsFetchingError_whenPreviousRequestIsBeingFetched() {
        let (sut, remoteArtsList, _) = buildSUT()

        sut.getArtsList(isRefreshing: false) { _ in }

        let exp = expectation(description: "Wait to complete second request")
        sut.getArtsList(isRefreshing: false) { result in
            switch result {
            case .success:
                XCTFail("Expected isFetching error but received \(result) instead.")
            case .failure(let error):
                XCTAssertEqual(error, .isFetching)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)

        XCTAssertTrue(remoteArtsList.receivedModel.count == 1)
    }

    // MARK: - Local UseCase
    func test_callsLocalUseCase_whenRemoteClientCompletesWithInvalidDataError() {
        let (sut, remoteArtsList, localArtsList) = buildSUT()

        sut.getArtsList(isRefreshing: false) { _ in }
        remoteArtsList.complete(with: .failure(.connection))

        XCTAssertTrue(remoteArtsList.receivedModel.count == 1)
        XCTAssertTrue(localArtsList.getArtsListCalled.count == 1)
    }

    func test_callsLocalUseCase_whenRemoteClientCompletesWithConnectionError() {
        let (sut, remoteArtsList, localArtsList) = buildSUT()

        sut.getArtsList(isRefreshing: false) { _ in }
        remoteArtsList.complete(with: .failure(.invalidData))

        XCTAssertTrue(remoteArtsList.receivedModel.count == 1)
        XCTAssertTrue(localArtsList.getArtsListCalled.count == 1)
    }

    func test_callsLocalUseCase_whenRemoteClientCompletesWithUnexpectedError() {
        let (sut, remoteArtsList, localArtsList) = buildSUT()

        sut.getArtsList(isRefreshing: false) { _ in }
        remoteArtsList.complete(with: .failure(.unexpected))

        XCTAssertTrue(remoteArtsList.receivedModel.count == 1)
        XCTAssertTrue(localArtsList.getArtsListCalled.count == 1)
    }

    // MARK: - Failures
    func test_deliversConnectionError_whenRemoteFailsWithConnectionAndLocalCompletesWithError() {
        expect(
            .failure(.connection),
            whenRemoteCompletesWith: .failure(.connection),
            andLocalCompletesWith: .failure(.unexpected)
        )

        expect(
            .failure(.connection),
            whenRemoteCompletesWith: .failure(.connection),
            andLocalCompletesWith: .failure(.invalidRequest)
        )
    }

    func test_deliverUnexpectedError_whenRemoteFailsWithUnexpectedAndLocalCompletesWithError() {
        expect(
            .failure(.unexpected),
            whenRemoteCompletesWith: .failure(.unexpected),
            andLocalCompletesWith: .failure(.invalidRequest)
        )

        expect(
            .failure(.unexpected),
            whenRemoteCompletesWith: .failure(.unexpected),
            andLocalCompletesWith: .failure(.unexpected)
        )
    }

    func test_deliversUnexpectedError_whenRemoteFailsAndLocalCompletesWithEmptyData() {
        expect(
            .failure(.unexpected),
            whenRemoteCompletesWith: .failure(.unexpected),
            andLocalCompletesWith: .success(nil)
        )
        expect(
            .failure(.unexpected),
            whenRemoteCompletesWith: .failure(.unexpected),
            andLocalCompletesWith: .success([])
        )

        expect(
            .failure(.unexpected),
            whenRemoteCompletesWith: .failure(.invalidData),
            andLocalCompletesWith: .success(nil)
        )
        expect(
            .failure(.unexpected),
            whenRemoteCompletesWith: .failure(.invalidData),
            andLocalCompletesWith: .success([])
        )
    }

    // MARK: - Success
    func test_deliversArtsList_whenRemoteFailsAndLocalCompletesWithValidData() {
        let expectedArtsList = makeDummyArtsList()
        expect(
            .success(expectedArtsList),
            whenRemoteCompletesWith: .failure(.connection),
            andLocalCompletesWith: .success(expectedArtsList)
        )

        expect(
            .success(expectedArtsList),
            whenRemoteCompletesWith: .failure(.unexpected),
            andLocalCompletesWith: .success(expectedArtsList)
        )

        expect(
            .success(expectedArtsList),
            whenRemoteCompletesWith: .failure(.invalidData),
            andLocalCompletesWith: .success(expectedArtsList)
        )
    }

    func test_deliversArtsList_whenRemoteCompletesWithValidData() {
        let expectedArtsList = makeDummyArtsList()
        let remoteArtsListToReturn = makeDummyArtsListResponseModel(with: expectedArtsList)
        expect(.success(expectedArtsList), whenRemoteCompletesWith: .success(remoteArtsListToReturn))
    }

    // MARK: - Save
    func test_savesCorrectArtsList_whenRemoteCompletesWithValidData() {
        let (sut, remoteArtsList, localArtsList) = buildSUT()
        let remoteArtsListToReturn = makeDummyArtsListResponseModel(with: makeDummyArtsList())
        let exp = expectation(description: "Wait to complete request")
        var artsListToSave: ArtsList = []
        
        sut.getArtsList(isRefreshing: false) { result in
            if case let .success(data) = result {
                artsListToSave = data
            }
            exp.fulfill()
        }
        remoteArtsList.complete(with: .success(remoteArtsListToReturn))
        wait(for: [exp], timeout: 1)

        XCTAssertEqual(localArtsList.receivedModelToSave, artsListToSave)
    }

    // MARK: - Memory Leak Track
    func test_doesNotComplete_whenSUTIsDeallocatedBeforeRemoteCompletion() {
        let remoteArtsList = RemoteArtsListSpy()
        var sut: ArtsListManager? = .init(
            remoteArtsList: remoteArtsList,
            localArtsList: LocalArtsListSpy()
        )
        var result: ArtsListResult?

        sut?.getArtsList(isRefreshing: false) {
            result = $0
        }
        sut = nil
        remoteArtsList.complete(with: .success(makeDummyArtsListResponseModel(with: makeDummyArtsList())))

        XCTAssertNil(result)
    }

    func test_doesNotComplete_whenSUTIsDeallocatedBeforeLocalCompletion() {
        let remoteArtsList = RemoteArtsListSpy()
        let localArtsList = LocalArtsListSpy()
        var sut: ArtsListManager? = .init(
            remoteArtsList: remoteArtsList,
            localArtsList: localArtsList
        )
        var result: ArtsListResult?

        sut?.getArtsList(isRefreshing: false) {
            result = $0
        }
        sut = nil
        remoteArtsList.complete(with: .failure(.connection))
        localArtsList.completeGetArtsList(with: .success(makeDummyArtsList()))

        XCTAssertNil(result)
    }
}

// MARK: - Helpers
extension ArtsListManagerTests {
    typealias SUT = (
        ArtsListManager,
        RemoteArtsListSpy,
        LocalArtsListSpy
    )

    private func buildSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> SUT {
        let remoteArtsList = RemoteArtsListSpy()
        let localArtsList = LocalArtsListSpy()
        let sut = ArtsListManager(
            remoteArtsList: remoteArtsList,
            localArtsList: localArtsList
        )
        checkMemoryLeak(for: sut, file: file, line: line)
        return (sut, remoteArtsList, localArtsList)
    }

    private func expect(
        _ expectedResult: ArtsListResult,
        whenRemoteCompletesWith remoteResult: RemoteArtListResult,
        andLocalCompletesWith localResult: LocalArtsListResult = .success(nil),
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let (sut, remoteArtsList, localArtsList) = buildSUT()
        let exp = expectation(description: "Wait to complete request")

        sut.getArtsList(isRefreshing: false) { receivedResult in
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

        remoteArtsList.complete(with: remoteResult)
        localArtsList.completeGetArtsList(with: localResult)
        wait(for: [exp], timeout: 1)
    }

    private func makeDummyArtsListResponseModel(with artsList: ArtsList) -> ArtsListResponseModel {
        let artsListData = map(artsList: artsList)
        return .init(data: artsListData)
    }

    private func makeDummyArtsListResponseModel() -> ArtsListResponseModel {
        let artsList = makeDummyArtsList()
        let artsListData = map(artsList: artsList)
        return .init(data: artsListData)
    }

    private func map(artsList: ArtsList) -> [ArtListData] {
        artsList.map {
            .init(
                artId: $0.artId,
                imageId: $0.imageId,
                title: $0.title,
                year: $0.year,
                author: $0.author
            )
        }
    }

    private func makeDummyArtsList() -> ArtsList {
        [
            .init(artId: Int.random(in: 1...5), imageId: nil, title: "any title", year: nil, author: nil),
            .init(artId: Int.random(in: 1...5), imageId: "any id", title: "any title", year: 1, author: "any author")
        ]
    }
}
