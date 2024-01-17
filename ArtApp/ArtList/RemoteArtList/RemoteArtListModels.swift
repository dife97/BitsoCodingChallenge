// MARK: - Request
public struct ArtListRequestModel: EquatableModel {
    let page: Int
    let limit: Int

    public init(
        page: Int,
        limit: Int
    ) {
        self.page = page
        self.limit = limit
    }
}

// MARK: - Response
public struct ArtListResponseModel: EquatableModel { // TODO: Change to use only decoder?
    let pagination: PaginationModel
    public let data: [ArtListData]

    public init(
        pagination: PaginationModel,
        data: [ArtListData]
    ) {
        self.pagination = pagination
        self.data = data
    }
}

public struct PaginationModel: EquatableModel {
    let currentPage: Int
    let offset: Int

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case offset
    }

    public init(
        currentPage: Int,
        offset: Int
    ) {
        self.currentPage = currentPage
        self.offset = offset
    }
}

public struct ArtListData: EquatableModel {
    public let id: Int
    public let imageId: String
    public let title: String
    public let year: Int
    public let author: String?

    enum CodingKeys: String, CodingKey {
        case id, title
        case imageId = "image_id"
        case year = "date_start"
        case author = "artist_title"
    }

    public init(
        id: Int,
        imageId: String,
        title: String,
        year: Int,
        author: String?
    ) {
        self.id = id
        self.imageId = imageId
        self.title = title
        self.year = year
        self.author = author
    }
}
