import XCTest

extension XCTestCase {
    func makeEmptyData() -> Data {
        .init()
    }

    func makeValidData() -> Data {
        .init("valid imageData".utf8)
    }
}
