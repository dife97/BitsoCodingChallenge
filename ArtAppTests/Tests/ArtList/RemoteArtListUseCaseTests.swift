import XCTest
import ArtApp

final class RemoteArtListUseCaseTests: XCTestCase {
    func test_paginating_forMultipleRequests() {
        let (sut, serviceSpy) = buildSUT()
        let expectedRequestModels: [ArtListRequestModel] = [
            .init(
                page: 1,
                limit: 10
            ),
            .init(
                page: 2,
                limit: 10
            ),
            .init(
                page: 3,
                limit: 10
            ),
            .init(
                page: 4,
                limit: 10
            ),
        ]

        expectedRequestModels.forEach { _ in
            sut.execute { _ in }
            serviceSpy.complete(with: .failure(.noConnection))
        }

        XCTAssertEqual(serviceSpy.receivedRequestModel, expectedRequestModels)
    }

    func test_deliversIsFetchingError_whenPreviousRequestIsBeingFetched() {
        let (sut, serviceSpy) = buildSUT()

        sut.execute { _ in }

        let exp = expectation(description: "Wait to complete second request")
        sut.execute { result in
            switch result {
            case .success:
                XCTFail("Expected isFetching error but received \(result) instead.")
            case .failure(let error):
                XCTAssertEqual(error, .isFetching)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)

        XCTAssertTrue(serviceSpy.receivedRequestModel.count == 1)
    }

    func test_deliversConnectionError_whenClientCompletesWithConnectionError() {
        let (sut, serviceSpy) = buildSUT()
        let exp = expectation(description: "Wait to complete request")

        sut.execute { result in
            switch result {
            case .success:
                XCTFail("Expected connection error but received \(result) instead.")
            case .failure(let error):
                XCTAssertEqual(error, .connection)
            }
            exp.fulfill()
        }

        serviceSpy.complete(with: .failure(.noConnection))
        wait(for: [exp], timeout: 1)
    }

    func test_deliversDataParsingError_whenClientCompletesWithInvalidData() {
        let (sut, serviceSpy) = buildSUT()
        let exp = expectation(description: "Wait to complete request")

        sut.execute { result in
            switch result {
            case .success:
                XCTFail("Expected dataParsing error but received \(result) instead.")
            case .failure(let error):
                XCTAssertEqual(error, .dataParsing)
            }
            exp.fulfill()
        }

        serviceSpy.complete(with: .failure(.invalidData))
        wait(for: [exp], timeout: 1)
    }

    func test_deliversArtList_whenClientCompletesWithValidData() {
        let (sut, serviceSpy) = buildSUT()
        let exp = expectation(description: "Wait to complete request")
        let expectedArtListResponse: ArtListResponseModel = .init(
            pagination: .init(currentPage: 2, offset: 0),
            data: [
                .init(id: "anyId", imageId: "anyImageId", title: "anyTitle", year: "anyYear", author: "anyAuthor")
            ]
        )
        let expectedArtListModel: ArtListModel = .init(artList: [
            .init(id: "anyId", imageId: "anyImageId", title: "anyTitle", year: "anyYear", author: "anyAuthor")
        ])

        sut.execute { result in
            switch result {
            case .success(let data):
                XCTAssertTrue(data.artList.first?.id == expectedArtListModel.artList.first?.id)

            case .failure:
                XCTFail("Expected artList but received \(result) instead.")
            }
            exp.fulfill()
        }

        serviceSpy.complete(with: .success(expectedArtListResponse))
        wait(for: [exp], timeout: 1)
    }

    func test_doesNotComplete_whenSUTIsDeallocatedBeforeClientCompletion() {
        let serviceSpy = RemoteArtListServiceSpy()
        var sut: RemoteArtListUseCase? = RemoteArtListUseCase(service: serviceSpy)
        var result: ArtListResult?

        sut?.execute { result = $0 }
        sut = nil
        serviceSpy.complete(with: .failure(.noConnection))

        XCTAssertNil(result)
    }
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