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
    let data: ArtListData
}

struct PaginationModel: Codable {
    let currentPage: Int
    let offset: Int

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case offset
    }
}

struct ArtListData: Codable {
    let id: String
    let imageId: String
    let title: String
    let year: String
    let author: String
}
