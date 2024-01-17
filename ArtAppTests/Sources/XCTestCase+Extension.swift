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
}
