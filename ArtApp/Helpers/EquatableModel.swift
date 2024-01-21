import Foundation

protocol EquatableModel: Codable, Equatable {}

extension EquatableModel {
    func toData() -> Data? {
        try? JSONEncoder().encode(self)
    }
}
