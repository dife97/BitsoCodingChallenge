public struct ArtListModel {
    public let artList: ArtList

    public init(artList: ArtList) {
        self.artList = artList
    }
}

public typealias ArtList = [ArtModel]

public struct ArtModel {
    public let id: String
    public let imageId: String
    public let title: String
    public let year: String
    public let author: String

    public init(
        id: String,
        imageId: String,
        title: String,
        year: String,
        author: String
    ) {
        self.id = id
        self.imageId = imageId
        self.title = title
        self.year = year
        self.author = author
    }
}
