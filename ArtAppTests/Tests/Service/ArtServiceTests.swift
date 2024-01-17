import XCTest
import ArtApp

final class ArtServiceTests: XCTestCase {
    // MARK: - Art List
    func test_getArtList_sendsCorrectTarget() {
        let providerSpy = HTTPProviderSpy()
        let sut = ArtService(provider: providerSpy)
        let requestModel: ArtListRequestModel = .init(page: 1, limit: 10)
        let getArtListTarget: ArtServiceTarget = .getArtList(requestModel)

        sut.getArtList(requestModel: requestModel) { _ in }

        XCTAssertEqual(providerSpy.receivedTarget?.method, getArtListTarget.method)
        XCTAssertEqual(providerSpy.receivedTarget?.path, getArtListTarget.path)
        XCTAssertEqual(providerSpy.receivedTarget?.headers, getArtListTarget.headers)
    }

    func test_getArtList_deliversUndefinedError_whenProviderCompletesWithInvalidURL() {
        let providerSpy = HTTPProviderSpy()
        let sut = ArtService(provider: providerSpy)
        let requestModel: ArtListRequestModel = .init(page: 1, limit: 10)
        let exp = expectation(description: "Wait for provider request")

        sut.getArtList(requestModel: requestModel) { result in
            switch result {
            case .success:
                XCTFail("Expected invalidURL error but received \(result) instead")

            case .failure(let error):
                XCTAssertEqual(error, .undefined)
            }
            exp.fulfill()
        }

        providerSpy.complete(with: .failure(.invalidRequest))
        wait(for: [exp], timeout: 1)
    }

    func test_getArtList_deliversUndefinedError_whenProviderCompletesWithInvalidData() {
        let providerSpy = HTTPProviderSpy()
        let sut = ArtService(provider: providerSpy)
        let requestModel: ArtListRequestModel = .init(page: 1, limit: 10)
        let exp = expectation(description: "Wait for provider request")

        sut.getArtList(requestModel: requestModel) { result in
            switch result {
            case .success:
                XCTFail("Expected invalidURL error but received \(result) instead")

            case .failure(let error):
                XCTAssertEqual(error, .undefined)
            }
            exp.fulfill()
        }

        providerSpy.complete(with: .failure(.invalidData))
        wait(for: [exp], timeout: 1)
    }

    func test_getArtList_deliversUndefinedError_whenProviderCompletesWithUndefined() {
        let providerSpy = HTTPProviderSpy()
        let sut = ArtService(provider: providerSpy)
        let requestModel: ArtListRequestModel = .init(page: 1, limit: 10)
        let exp = expectation(description: "Wait for provider request")

        sut.getArtList(requestModel: requestModel) { result in
            switch result {
            case .success:
                XCTFail("Expected invalidURL error but received \(result) instead")

            case .failure(let error):
                XCTAssertEqual(error, .undefined)
            }
            exp.fulfill()
        }

        providerSpy.complete(with: .failure(.undefined))
        wait(for: [exp], timeout: 1)
    }

    func test_getArtList_deliversDataParsingError_whenProviderCompletesWithInvalidData() {
        let providerSpy = HTTPProviderSpy()
        let sut = ArtService(provider: providerSpy)
        let requestModel: ArtListRequestModel = .init(page: 1, limit: 10)
        let expetedInvalidData = Data()
        let exp = expectation(description: "Wait for provider request")

        sut.getArtList(requestModel: requestModel) { result in
            switch result {
            case .success:
                XCTFail("Expected invalidURL error but received \(result) instead")

            case .failure(let error):
                XCTAssertEqual(error, .dataParsing)
            }
            exp.fulfill()
        }

        providerSpy.complete(with: .success(expetedInvalidData))
        wait(for: [exp], timeout: 1)
    }

    func test_getArtList_deliversData_whenProviderCompletesWithValidData() {
        let providerSpy = HTTPProviderSpy()
        let sut = ArtService(provider: providerSpy)
        let requestModel: ArtListRequestModel = .init(page: 1, limit: 10)
        let expetedResponseData: ArtListResponseModel = .init(
            pagination: .init(
                currentPage: 1,
                offset: 0
            ),
            data: [
                .init(artId: 123, imageId: "any", title: "any", year: 123, author: "any")
            ]
        )
        let exp = expectation(description: "Wait for provider request")

        sut.getArtList(requestModel: requestModel) { result in
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
