public struct ArtImageError: Error {
    public let artId: Int
    let type: GetArtImageError
}

public enum GetArtImageError {
    case artImageUnavailable
    case connection
    case undefined
}
