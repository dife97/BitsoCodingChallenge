// MARK: - Request
public struct ArtsListRequestModel: EquatableModel {
    let page: Int
    let limit: Int

    init(
        page: Int,
        limit: Int
    ) {
        self.page = page
        self.limit = limit
    }
}

// MARK: - Response
public struct ArtsListResponseModel: EquatableModel {
    let data: [ArtListData]

    init(data: [ArtListData]) {
        self.data = data
    }
}

struct ArtListData: EquatableModel {
    let artId: Int
    let imageId: String?
    let title: String
    let year: Int?
    let author: String?

    enum CodingKeys: String, CodingKey {
        case artId = "id"
        case imageId = "image_id"
        case title
        case year = "date_start"
        case author = "artist_title"
    }

    init(
        artId: Int,
        imageId: String?,
        title: String,
        year: Int?,
        author: String?
    ) {
        self.artId = artId
        self.imageId = imageId
        self.title = title
        self.year = year
        self.author = author
    }
}
