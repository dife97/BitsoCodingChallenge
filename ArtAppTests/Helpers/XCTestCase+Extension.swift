import XCTest

extension XCTestCase {
    func isDictionary(_ dictionary: [String: Any]?, equalTo dictionaryToCompare: [String: Any]?) -> Bool {
        guard
            let dictionary,
            let dictionaryToCompare
        else {
            return false
        }

        return NSDictionary(dictionary: dictionary).isEqual(to: dictionaryToCompare)
    }

    func checkMemoryLeak(
        for instance: AnyObject,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, file: file, line: line)
        }
    }
}
