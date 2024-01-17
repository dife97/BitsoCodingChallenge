import XCTest
import ArtApp

extension ArtServiceTests {
    func test_getImage_sendCorrectTarget() {
        let (sut, providerSpy) = buildSUT()
        let imageRequestModel: ArtImageRequestModel = .init(imagedId: "anyId")
        let getArtListTarget: ArtServiceTarget = .getImage(imageRequestModel)

        sut.getArtImage(requestModel: imageRequestModel) { _ in }

        XCTAssertEqual(providerSpy.receivedTarget?.server, getArtListTarget.server)
        XCTAssertEqual(providerSpy.receivedTarget?.method, getArtListTarget.method)
        XCTAssertEqual(providerSpy.receivedTarget?.path, getArtListTarget.path)
        XCTAssertEqual(providerSpy.receivedTarget?.headers, getArtListTarget.headers)
        XCTAssertNil(providerSpy.receivedTarget?.parameters)
    }

    func test_getImage_deliversUndefinedError_whenProviderCompletesWithInvalidURL() {
        let (sut, providerSpy) = buildSUT()
        let imageRequestModel: ArtImageRequestModel = .init(imagedId: "anyId")
        let exp = expectation(description: "Wait for provider request")

        sut.getArtImage(requestModel: imageRequestModel) { result in
            switch result {
            case .success(_):
                XCTFail("Expected undefined error but received \(result) instead")
            case .failure(let error):
                XCTAssertEqual(error, .undefined)
            }
            exp.fulfill()
        }
        providerSpy.complete(with: .failure(.invalidRequest))
        wait(for: [exp], timeout: 1)
    }

    func test_getImage_deliversUndefinedError_whenProviderCompletesWithInvalidData() {
        let (sut, providerSpy) = buildSUT()
        let imageRequestModel: ArtImageRequestModel = .init(imagedId: "anyId")
        let exp = expectation(description: "Wait for provider request")

        sut.getArtImage(requestModel: imageRequestModel) { result in
            switch result {
            case .success(_):
                XCTFail("Expected undefined error but received \(result) instead")
            case .failure(let error):
                XCTAssertEqual(error, .undefined)
            }
            exp.fulfill()
        }
        providerSpy.complete(with: .failure(.invalidData))
        wait(for: [exp], timeout: 1)
    }

    func test_getImage_deliversUndefinedError_whenProviderCompletesWithUndefined() {
        let (sut, providerSpy) = buildSUT()
        let imageRequestModel: ArtImageRequestModel = .init(imagedId: "anyId")
        let exp = expectation(description: "Wait for provider request")

        sut.getArtImage(requestModel: imageRequestModel) { result in
            switch result {
            case .success(_):
                XCTFail("Expected undefined error but received \(result) instead")
            case .failure(let error):
                XCTAssertEqual(error, .undefined)
            }
            exp.fulfill()
        }
        providerSpy.complete(with: .failure(.undefined))
        wait(for: [exp], timeout: 1)
    }

    func test_getImage_deliversEmptyDataError_whenProviderCompletesWithEmptyData() {
        let (sut, providerSpy) = buildSUT()
        let imageRequestModel: ArtImageRequestModel = .init(imagedId: "anyId")
        let exp = expectation(description: "Wait for provider request")
        let emptyImageData = makeEmptyData()

        sut.getArtImage(requestModel: imageRequestModel) { result in
            switch result {
            case .success(_):
                XCTFail("Expected emptyData error but received \(result) instead")
            case .failure(let error):
                XCTAssertEqual(error, .emptyData)
            }
            exp.fulfill()
        }
        providerSpy.complete(with: .success(emptyImageData))
        wait(for: [exp], timeout: 1)
    }

    func test_getImage_deliversEmptyDataError_whenProviderCompletesWithNilData() {
        let (sut, providerSpy) = buildSUT()
        let imageRequestModel: ArtImageRequestModel = .init(imagedId: "anyId")
        let exp = expectation(description: "Wait for provider request")

        sut.getArtImage(requestModel: imageRequestModel) { result in
            switch result {
            case .success(_):
                XCTFail("Expected emptyData error but received \(result) instead")
            case .failure(let error):
                XCTAssertEqual(error, .emptyData)
            }
            exp.fulfill()
        }
        providerSpy.complete(with: .success(nil))
        wait(for: [exp], timeout: 1)
    }

    func test_getImage_deliversData_whenProviderCompletesWithValidData() {
        let (sut, providerSpy) = buildSUT()
        let imageRequestModel: ArtImageRequestModel = .init(imagedId: "anyId")
        let exp = expectation(description: "Wait for provider request")
        let validImageData = makeValidData()
        let expectedResponseData: ArtImageResponse = .init(imageData: validImageData)

        sut.getArtImage(requestModel: imageRequestModel) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data, expectedResponseData)

            case .failure:
                XCTFail("Expected success with valid data but received \(result) instead")
            }
            exp.fulfill()
        }
        providerSpy.complete(with: .success(makeValidData()))
        wait(for: [exp], timeout: 1)
    }
}

// MARK: - Helpers
extension ArtServiceTests {
    typealias SUT = (
        ArtService,
        HTTPProviderSpy
    )
    private func buildSUT() -> SUT {
        let providerSpy = HTTPProviderSpy()
        let sut = ArtService(provider: providerSpy)
        return (sut, providerSpy)
    }
}
