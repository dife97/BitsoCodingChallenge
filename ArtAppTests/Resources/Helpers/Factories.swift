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
            artId: "any id",
            title: "any title",
            date: "any data",
            artistInfo: "any info",
            description: "any description",
            place: "any place",
            medium: "any medium",
            dimensions: "any dimensions"
        ))
    }
}
