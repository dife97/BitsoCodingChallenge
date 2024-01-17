import Foundation

public final class RemoteGetArtImagesUseCase: GetArtImagesProtocol {
    // MARK: - Dependency
    private let service: GetImageServiceProtocol

    // MARK: - Initializer
    public init(service: GetImageServiceProtocol) {
        self.service = service
    }

    // MARK: - Public Method
    public func execute(
        with images: GetArtImagesRequestModel,
        _ completion: @escaping (GetArtImagesResult) -> Void
    ) {
        images.forEach { imageRequestModel in
            guard let imageId = imageRequestModel.imagedId else {
                return completion(.failure(.init(
                    artId: imageRequestModel.artId,
                    type: .artImageUnavailable
                )))
            }

            let artImageRequestModel: ArtImageRequestModel = .init(imagedId: imageId)

            service.getImage(requestModel: artImageRequestModel) { [weak self] result in
                guard let self else { return }

                switch result {
                case .success(let response):
                    if response.imageData.isEmpty {
                        completion(.failure(.init(
                            artId: imageRequestModel.artId,
                            type: .artImageUnavailable
                        )))
                    } else {
                        completion(.success(.init(
                            artId: imageRequestModel.artId,
                            imageData: response.imageData
                        )))
                    }

                case .failure(let error):
                    completion(.failure(.init(
                        artId: imageRequestModel.artId,
                        type: getArtImageError(from: error)
                    )))
                }
            }
        }
    }
}

// MARK: - Private Methods
extension RemoteGetArtImagesUseCase {
    private func getArtImageError(from serviceError: GetImageServiceError) -> GetArtImageError {
        switch serviceError {
        case .connection:
            return .connection
        case .dataParsing, .undefined:
            return .undefined
        }
    }
}
