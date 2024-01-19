import XCTest
import ArtApp

final class RemoteGetArtImagesUseCaseTests: XCTestCase {
    func test_executes_forAllImages() {
        let (sut, serviceSpy) = buildSUT()
        let imagesRequestModel: GetArtImagesRequestModel = [
            .init(
                artId: 11,
                imagedId: "anyImageId"
            ),
            .init(
                artId: 12,
                imagedId: "anyImageId"
            ),
            .init(
                artId: 13,
                imagedId: "anyImageId"
            ),
            .init(
                artId: 14,
                imagedId: "anyImageId"
            ),
            .init(
                artId: 15,
                imagedId: "anyImageId"
            ),
        ]

        sut.execute(with: imagesRequestModel) { _ in }

        XCTAssertEqual(serviceSpy.receivedImageRequestModels.count, imagesRequestModel.count)
    }

    func test_deliversArtImageUnavailableError_whenImageIdIsNil() {
        let (sut, serviceSpy) = buildSUT()
        let imagesRequestModel: GetArtImagesRequestModel = [
            .init(
                artId: 11,
                imagedId: "anyImageId"
            ),
            .init(
                artId: 12,
                imagedId: nil
            ),
            .init(
                artId: 13,
                imagedId: "anyImageId"
            ),
            .init(
                artId: 14,
                imagedId: nil
            ),
            .init(
                artId: 15,
                imagedId: "anyImageId"
            ),
        ]
        var artImageErrors: [ArtImageError] = []

        sut.execute(with: imagesRequestModel) { result in
            switch result {
            case .success:
                XCTFail("Expected artImageUnavailable error but received \(result) instead")
            case .failure(let error):
                artImageErrors.append(error)
            }
        }

        artImageErrors.forEach {
            XCTAssertEqual($0.type, .artImageUnavailable)
        }

        XCTAssertEqual(serviceSpy.receivedImageRequestModels.count, 3)
    }

    func test_deliversCorrectArtId_whenImageIdIsNil() {
        let (sut, _) = buildSUT()
        let imagesRequestModel: GetArtImagesRequestModel = [
            .init(
                artId: 11,
                imagedId: nil
            ),
            .init(
                artId: 12,
                imagedId: nil
            )
        ]
        var artImageErrors: [ArtImageError] = []

        sut.execute(with: imagesRequestModel) { result in
            switch result {
            case .success:
                XCTFail("Expected artImageUnavailable error but received \(result) instead")
            case .failure(let error):
                artImageErrors.append(error)
            }
        }

        XCTAssertEqual(artImageErrors[0].artId, imagesRequestModel[0].artId)
        XCTAssertEqual(artImageErrors[1].artId, imagesRequestModel[1].artId)
    }

    func test_deliversConnectionError_whenClientCompletesWithConnectionError() {
        let (sut, serviceSpy) = buildSUT()
        let imagesRequestModel: GetArtImagesRequestModel = [
            .init(
                artId: 11,
                imagedId: "anyImageId"
            )
        ]
        let exp = expectation(description: "Wait to complet request")
        sut.execute(with: imagesRequestModel) { result in
            switch result {
            case .success:
                XCTFail("Expected connection error but received \(result) instead")
            case .failure(let error):
                XCTAssertEqual(error.artId, imagesRequestModel.first?.artId)
                XCTAssertEqual(error.type, .connection)
            }
            exp.fulfill()
        }
        serviceSpy.complete(with: .failure(.connection))
        wait(for: [exp], timeout: 1)
    }

    func test_deliversUndefinedError_whenClientCompletesWithUndefinedError() {
        let (sut, serviceSpy) = buildSUT()
        let imagesRequestModel: GetArtImagesRequestModel = [
            .init(
                artId: 11,
                imagedId: "anyImageId"
            )
        ]
        let exp = expectation(description: "Wait to complet request")
        sut.execute(with: imagesRequestModel) { result in
            switch result {
            case .success:
                XCTFail("Expected connection error but received \(result) instead")
            case .failure(let error):
                XCTAssertEqual(error.artId, imagesRequestModel.first?.artId)
                XCTAssertEqual(error.type, .undefined)
            }
            exp.fulfill()
        }
        serviceSpy.complete(with: .failure(.undefined))
        wait(for: [exp], timeout: 1)
    }

    func test_deliversUndefinedError_whenClientCompletesWithDataParsingError() {
        let (sut, serviceSpy) = buildSUT()
        let imagesRequestModel: GetArtImagesRequestModel = [
            .init(
                artId: 11,
                imagedId: "anyImageId"
            )
        ]
        let exp = expectation(description: "Wait to complet request")
        sut.execute(with: imagesRequestModel) { result in
            switch result {
            case .success:
                XCTFail("Expected connection error but received \(result) instead")
            case .failure(let error):
                XCTAssertEqual(error.artId, imagesRequestModel.first?.artId)
                XCTAssertEqual(error.type, .undefined)
            }
            exp.fulfill()
        }
        serviceSpy.complete(with: .failure(.emptyData))
        wait(for: [exp], timeout: 1)
    }

    func test_deliversArtImageUnavailableError_whenClientCompletesWithEmptyImageData() {
        let (sut, serviceSpy) = buildSUT()
        let imagesRequestModel: GetArtImagesRequestModel = [
            .init(
                artId: 11,
                imagedId: "anyImageId"
            )
        ]
        let exp = expectation(description: "Wait to complet request")
        sut.execute(with: imagesRequestModel) { result in
            switch result {
            case .success:
                XCTFail("Expected connection error but received \(result) instead")
            case .failure(let error):
                XCTAssertEqual(error.artId, imagesRequestModel.first?.artId)
                XCTAssertEqual(error.type, .artImageUnavailable)
            }
            exp.fulfill()
        }
        serviceSpy.complete(with: .success(.init(imageData: makeEmptyData())))
        wait(for: [exp], timeout: 1)
    }

    func test_deliversImageData_whenClientCompletesWithValidImageData() {
        let (sut, serviceSpy) = buildSUT()
        let imagesRequestModel: GetArtImagesRequestModel = [
            .init(
                artId: 11,
                imagedId: "anyImageId"
            )
        ]
        let exp = expectation(description: "Wait to complete request")
        sut.execute(with: imagesRequestModel) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data.artId, imagesRequestModel.first?.artId)
                XCTAssertFalse(data.imageData.isEmpty)

            case .failure:
                XCTFail("Expected imageData but received \(result) instead")
            }
            exp.fulfill()
        }
        serviceSpy.complete(with: .success(.init(imageData: makeValidData())))
        wait(for: [exp], timeout: 1)
    }

    func test_doesNotComplete_whenSUTIsDeallocatedBeforeClientCompletion() {
        let serviceSpy = RemoteGetImageServiceSpy()
        var sut: RemoteGetArtImagesUseCase? = RemoteGetArtImagesUseCase(service: serviceSpy)
        let imagesRequestModel: GetArtImagesRequestModel = [
            .init(
                artId: 11,
                imagedId: "anyImageId"
            )
        ]
        var result: GetArtImagesResult?

        sut?.execute(with: imagesRequestModel) { result = $0 }
        sut = nil
        serviceSpy.complete(with: .failure(.connection))

        XCTAssertNil(result)
    }
}

// MARK: - Helpers
extension RemoteGetArtImagesUseCaseTests {
    typealias SUT = (
        RemoteGetArtImagesUseCase,
        RemoteGetImageServiceSpy
    )

    private func buildSUT() -> SUT {
        let serviceSpy = RemoteGetImageServiceSpy()
        let sut = RemoteGetArtImagesUseCase(service: serviceSpy)
        return (sut, serviceSpy)
    }
}
