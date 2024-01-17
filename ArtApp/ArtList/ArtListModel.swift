public struct ArtListModel {
    public let artList: ArtList

    public init(artList: ArtList) {
        self.artList = artList
    }
}

public typealias ArtList = [ArtModel]

public struct ArtModel {
    public let artId: Int
    public let imageId: String?
    public let title: String
    public let year: Int
    public let author: String?

    public init(
        artId: Int,
        imageId: String?,
        title: String,
        year: Int,
        author: String?
    ) {
        self.artId = artId
        self.imageId = imageId
        self.title = title
        self.year = year
        self.author = author
    }
}
