struct ArtDetailsSetupModel {
    let description: String?
    let details: ArtDetails
}

typealias ArtDetails = [ArtDetailItemModel]

struct ArtDetailItemModel {
    let title: String
    let description: String
}
