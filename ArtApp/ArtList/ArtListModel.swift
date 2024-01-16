struct ArtListModel {
    let artList: ArtList
}

typealias ArtList = [ArtModel]

struct ArtModel {
    let id: String
    let imageId: String
    let title: String
    let year: String
    let author: String
}
