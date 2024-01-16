public protocol EquatableModel: Equatable {} // TODO: Move to own file

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
public struct ArtListResponseModel: Codable { // TODO: Change to use only decoder?
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

public struct PaginationModel: Codable {
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

public struct ArtListData: Codable {
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
