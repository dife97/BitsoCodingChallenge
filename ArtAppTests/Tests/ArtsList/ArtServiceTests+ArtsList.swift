import XCTest
@testable import ArtApp

extension ArtServiceTests {
    // MARK: - Art List
    func test_getArtsList_sendsCorrectTarget() {
        let providerSpy = HTTPProviderSpy()
        let sut = ArtService(provider: providerSpy)
        let requestModel: ArtsListRequestModel = .init(page: 1, limit: 10)
        let getArtListTarget: ArtServiceTarget = .getArtList(requestModel)

        sut.getArtsList(requestModel: requestModel) { _ in }

        assertArtServiceTarget(getArtListTarget, from: providerSpy)
    }

    func test_getArtsList_deliversUnexpectedError_whenProviderCompletesWithInvalidRequest() {
        let providerSpy = HTTPProviderSpy()
        let sut = ArtService(provider: providerSpy)
        let requestModel: ArtsListRequestModel = .init(page: 1, limit: 10)
        let exp = expectation(description: "Wait for provider request")

        sut.getArtsList(requestModel: requestModel) { result in
            switch result {
            case .success:
                XCTFail("Expected invalidURL error but received \(result) instead")

            case .failure(let error):
                XCTAssertEqual(error, .unexpected)
            }
            exp.fulfill()
        }

        providerSpy.complete(with: .failure(.invalidRequest))
        wait(for: [exp], timeout: 1)
    }

    func test_getArtsList_deliversUnexpectedError_whenProviderCompletesWithInvalidData() {
        let providerSpy = HTTPProviderSpy()
        let sut = ArtService(provider: providerSpy)
        let requestModel: ArtsListRequestModel = .init(page: 1, limit: 10)
        let exp = expectation(description: "Wait for provider request")

        sut.getArtsList(requestModel: requestModel) { result in
            switch result {
            case .success:
                XCTFail("Expected undefined error but received \(result) instead")

            case .failure(let error):
                XCTAssertEqual(error, .unexpected)
            }
            exp.fulfill()
        }

        providerSpy.complete(with: .failure(.invalidData))
        wait(for: [exp], timeout: 1)
    }

    func test_getArtsList_deliversUnexpectedError_whenProviderCompletesWithUnexpected() {
        let providerSpy = HTTPProviderSpy()
        let sut = ArtService(provider: providerSpy)
        let requestModel: ArtsListRequestModel = .init(page: 1, limit: 10)
        let exp = expectation(description: "Wait for provider request")

        sut.getArtsList(requestModel: requestModel) { result in
            switch result {
            case .success:
                XCTFail("Expected undefined error but received \(result) instead")

            case .failure(let error):
                XCTAssertEqual(error, .unexpected)
            }
            exp.fulfill()
        }

        providerSpy.complete(with: .failure(.unexpected))
        wait(for: [exp], timeout: 1)
    }

    func test_getArtsList_deliversInvalidDataError_whenProviderCompletesWithInvalidData() {
        let providerSpy = HTTPProviderSpy()
        let sut = ArtService(provider: providerSpy)
        let requestModel: ArtsListRequestModel = .init(page: 1, limit: 10)
        let expetedInvalidData = Data()
        let exp = expectation(description: "Wait for provider request")

        sut.getArtsList(requestModel: requestModel) { result in
            switch result {
            case .success:
                XCTFail("Expected dataParsing error but received \(result) instead")

            case .failure(let error):
                XCTAssertEqual(error, .invalidData)
            }
            exp.fulfill()
        }

        providerSpy.complete(with: .success(expetedInvalidData))
        wait(for: [exp], timeout: 1)
    }

    func test_getArtsList_deliversData_whenProviderCompletesWithValidData() {
        let providerSpy = HTTPProviderSpy()
        let sut = ArtService(provider: providerSpy)
        let requestModel: ArtsListRequestModel = .init(page: 1, limit: 10)
        let expetedResponseData: ArtsListResponseModel = .init(data: [
            .init(artId: 123, imageId: "any", title: "any", year: 123, author: "any")
        ])
        let exp = expectation(description: "Wait for provider request")

        sut.getArtsList(requestModel: requestModel) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data, expetedResponseData)

            case .failure:
                XCTFail("Expected success with valid data but received \(result) instead")
            }
            exp.fulfill()
        }

        providerSpy.complete(with: .success(expetedResponseData.toData()))
        wait(for: [exp], timeout: 1)
    }
}
