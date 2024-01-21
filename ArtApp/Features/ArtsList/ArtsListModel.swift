public typealias ArtsList = [ArtModel]
extension ArtsList: EquatableModel {}

public struct ArtModel: EquatableModel {
    public let artId: Int
    public let imageId: String?
    public let title: String
    public let year: Int?
    public let author: String?

//    init(
//        artId: Int,
//        imageId: String?,
//        title: String,
//        year: Int?,
//        author: String?
//    ) {
//        self.artId = artId
//        self.imageId = imageId
//        self.title = title
//        self.year = year
//        self.author = author
//    }
}
