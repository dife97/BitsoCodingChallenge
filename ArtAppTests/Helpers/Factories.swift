import XCTest
@testable import ArtApp

extension XCTestCase {
    func makeEmptyData() -> Data {
        .init()
    }

    func makeInvalidData() -> Data {
        .init("invalid data".utf8)
    }

    func makeValidData() -> Data {
        .init("valid imageData".utf8)
    }

    // MARK: - Art Details
    func makeDummyArtDetailsRequestModel() -> ArtDetailsRequestModel {
        .init(artId: Int.random(in: 1...10))
    }

    func makeDummyArtDetailsResponseModel() -> ArtDetailsResponseModel {
        .init(data: .init(
            artId: 0,
            description: "any description",
            place: "any place",
            date: "any date",
            medium: "any medium",
            inscriptions: "any inscription",
            dimensions: "any dimension",
            creditLine: "any credit line",
            referenceNumber: "any reference"
        ))
    }
}
