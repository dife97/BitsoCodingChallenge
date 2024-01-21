public typealias ArtsList = [ArtModel]
extension ArtsList: EquatableModel {}

public struct ArtModel: EquatableModel {
    public let artId: Int
    public let imageId: String?
    public let title: String
    public let year: Int?
    public let author: String?
}
