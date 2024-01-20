import ArtStore

enum ArtStoreTarget {
    case artsList
}

extension ArtStoreTarget: StoreTarget {
    var path: String {
        "arts-list"
    }
}
