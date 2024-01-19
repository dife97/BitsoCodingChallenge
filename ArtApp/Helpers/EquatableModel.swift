import Foundation

public protocol EquatableModel: Codable, Equatable {}

public extension EquatableModel {
    func toData() -> Data? {
        try? JSONEncoder().encode(self)
    }
}
