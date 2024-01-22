import XCTest
@testable import ArtApp

final class ArtServiceTests: XCTestCase {
    typealias SUT = (
        ArtService,
        HTTPProviderSpy
    )

    func buildSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> SUT {
        let providerSpy = HTTPProviderSpy()
        let sut = ArtService(provider: providerSpy)
        checkMemoryLeak(for: sut, file: file, line: line)
        return (sut, providerSpy)
    }

    func assertArtServiceTarget(
        _ artServiceTarge: ArtServiceTarget,
        from providerSpy: HTTPProviderSpy,
        hasParameters: Bool = true,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertEqual(providerSpy.receivedTarget?.server, artServiceTarge.server, file: file, line: line)
        XCTAssertEqual(providerSpy.receivedTarget?.method, artServiceTarge.method, file: file, line: line)
        XCTAssertEqual(providerSpy.receivedTarget?.path, artServiceTarge.path, file: file, line: line)
        XCTAssertEqual(providerSpy.receivedTarget?.headers, artServiceTarge.headers, file: file, line: line)
        
        if hasParameters {
            XCTAssertTrue(isDictionary(
                providerSpy.receivedTarget?.parameters,
                equalTo: artServiceTarge.parameters
            ), file: file, line: line)
        } else {
            XCTAssertNil(providerSpy.receivedTarget?.parameters, file: file, line: line)
        }
    }
}
